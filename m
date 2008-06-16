Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYFPG7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYFPG7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYFPG7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:59:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54449 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYFPG7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:59:23 -0400
Date: Mon, 16 Jun 2008 15:59:25 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1213598394.16944.85.camel@twins>
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1213598394.16944.85.camel@twins>
Message-Id: <20080616155630.78A9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> > # mount -t cgroup -o task none /dev/cgroup
> > # mkdir /dev/cgroup/foo
> > # cd /dev/cgroup/foo
> > # ls 
> > notify_on_release  task.max_tasks  task.nr_tasks  tasks
> > # echo 100 > task.max_tasks
> > # echo $$ > tasks
> > # fork_bomb 1000 &  <- try create 1000 process
> > # pgrep fork_bomb | wc -l
> > 98
> 
> fwiw I think the name sucks!
> cgroups are about grouping tasks, so what's a task cgroup?

Sorry, my english skill is very low.
I hope restrict number of tasks.

Do you have any name idea?



