Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYFPBcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYFPBcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYFPBcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:32:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38254 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYFPBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:32:41 -0400
Date: Mon, 16 Jun 2008 10:32:46 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <6599ad830806110045n6aec52ddkfb4be91b685357fe@mail.gmail.com>
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com> <6599ad830806110045n6aec52ddkfb4be91b685357fe@mail.gmail.com>
Message-Id: <20080616103035.788A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

very sorry, late responce.

> > +struct task_cgroup {
> > +       struct cgroup_subsys_state css;
> > +       /*
> > +        * the counter to account for number of thread.
> > +        */
> > +       int max_tasks;
> > +       int nr_tasks;
> > +
> > +       spinlock_t lock;
> > +};
> 
> This looks rather like a res_counter. Can you resuse that rather than
> implementing your own read/write/charge/uncharge routines?

honestly, I used res_counter on early version.
but I got bad performance.
tus, I changed to current implementation.

Of cource, if res_counter become faster, I'll use it.



