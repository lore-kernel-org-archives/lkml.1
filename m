Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbZB0AWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbZB0AWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZB0AVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:21:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34730 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZB0AVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:21:51 -0500
Date: Fri, 27 Feb 2009 09:20:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       menage@google.com, lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] cgroup allow subsys to set default mode of its own
 file
Message-Id: <20090227092031.f42cbbbe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090226130005.3282cb02.akpm@linux-foundation.org>
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com>
	<20090226130005.3282cb02.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 13:00:05 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 Feb 2009 16:35:55 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> >  When I wrote tools for maintain cgroup, I can't find which file is
> >  writable intarfece or not via cgroup file systems. (finally, I did
> >  dirty approach.)
> >  IMHO, showing "this file is read-only" in explicit way is useful
> >  for user-land (tools). In other story, a file whose name sounds read-only
> >  may have "trigger" operation and support reseting. In this case,
> >  "writable" is informative.
> 
> Well, we have compatibility issues here.  If we make this change, and
> people write tools which depend upon that change then those tools might
> break when run upon older kernels.  Or they need back-compatibility
> additions, which increases the testing burden of those tools.
> 
> One way in which we could improve this situation is to backport these
> changes into earlier kernels, although I don't know which versions.
> 
> What do we think?
> 
It sounds problem to me.

Hmm..1st commit to kernel/cgroup.c is 2007-10-19, then 2.6.24 is the oldest one.
But I think distro's tools for cgroup is not as old as...
Hmm, backport to 2.6.25 is enough ?
Balbir, how do you think ? I think you are familiar with libcgroup.

Thanks,
-Kame

