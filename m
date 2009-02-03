Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZBCK6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZBCK6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 05:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZBCK6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 05:58:02 -0500
Received: from styx.suse.cz ([82.119.242.94]:33542 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751707AbZBCK6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 05:58:01 -0500
Date: Tue, 3 Feb 2009 11:57:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] trivial: Give the right path in Documentation example
In-Reply-To: <20090203103056.c4e097b3.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LNX.1.10.0902031157380.11630@jikos.suse.cz>
References: <1233614376-27654-1-git-send-email-cascardo@holoscopio.com> <20090203103056.c4e097b3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, KAMEZAWA Hiroyuki wrote:

> > While the Documentation example creates /cgroup/test, it removes
> > /test/cgroup, which is clearly not the intended path. Change that to
> > /cgroup/test.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > ---
> >  Documentation/cgroups/memcg_test.txt |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
> > index 523a9c1..a926359 100644
> > --- a/Documentation/cgroups/memcg_test.txt
> > +++ b/Documentation/cgroups/memcg_test.txt
> > @@ -356,7 +356,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
> >  	(Shell-B)
> >  	# move all tasks in /cgroup/test to /cgroup
> >  	# /sbin/swapoff -a
> > -	# rmdir /test/cgroup
> > +	# rmdir /cgroup/test
> >  	# kill malloc task.
> >  
> >  	Of course, tmpfs v.s. swapoff test should be tested, too.

Applied to trivial tree, thanks guys.

-- 
Jiri Kosina
SUSE Labs
