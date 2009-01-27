Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZA0KlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZA0KlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 05:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZA0KlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 05:41:05 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49353 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZA0KlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 05:41:02 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
In-Reply-To: <20090127093105.GB2646@ioremap.net>
References: <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com> <20090127093105.GB2646@ioremap.net>
Message-Id: <20090127193058.D48B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 19:40:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

> On Mon, Jan 26, 2009 at 11:51:27PM -0800, David Rientjes (rientjes@google.com) wrote:
> > Yeah, I proposed /dev/mem_notify being made as a client of cgroups there 
> > in http://marc.info/?l=linux-kernel&m=123200623628685
> > 
> > How do you replace the oom killer's capability of giving a killed task 
> > access to memory reserves with TIF_MEMDIE in userspace?
> 
> /dev/mem_notify is a great idea, but please do not limit existing
> oom-killer in its ability to do the job and do not rely on application's
> ability to send a SIGKILL which will not kill tasks in unkillable state
> contrary to oom-killer.

I'd like to respect your requiremnt. but I also would like to know
why you like deterministic hierarchy oom than notification.

I think one of problem is, current patch description is a bit poor
and don't describe from administrator view.

Could you please sort the discssion out and explain your requirement detail?
otherwise (I guess) this discussion don't reach people agreement.

I don't like the implementation idea vs another idea discussion.
it often don't make productive discussion.
I'd like to sort out people requrement.
otherwise I can't review the patch fill requirement or not.



