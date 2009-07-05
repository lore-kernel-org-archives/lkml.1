Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZGEGjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZGEGjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 02:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZGEGix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 02:38:53 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51796 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZGEGiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 02:38:52 -0400
Date: Sun, 5 Jul 2009 12:08:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitzu.com, serue@us.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, bblum@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
Message-ID: <20090705063850.GX11273@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* menage@google.com <menage@google.com> [2009-07-02 16:26:15]:

> The following series (written by Ben Blum) adds a "cgroup.procs" file
> to each cgroup that reports unique tgids rather than pids, and fixes a
> pid namespace bug in the existing "tasks" file that could cause
> readers in different namespaces to interfere with one another.
> 
> The patches as a pair provide similar functionality to Li Zefan's
> patch posted yesterday, with the addition on the "cgroup.procs" file;
> if it's decided that Li's patch needs to be fast-tracked to 2.6.31,
> then these patches can be rebased as a small extension of Li's patch;
> if Li'z patch doesn't need to go to 2.6.31 then it makes more sense to
> take this pair since they provide more overall functionality.
>

Paul, I don't see an interface to migrate all procs or at-least I
can't read it in the changelog. As discussed in the containers
mini-summit in 2008, it would be a nice thing to have (I've not looked
at the implementation yet).
 
> ---
> 
> Ben Blum (2):
>       Adds a read-only "procs" file similar to "tasks" that shows only unique tgids
>       Ensures correct concurrent opening/reading of pidlists across pid namespaces
> 
> 
>  include/linux/cgroup.h |   46 +++++-
>  kernel/cgroup.c        |  355 +++++++++++++++++++++++++++++++++---------------
>  2 files changed, 285 insertions(+), 116 deletions(-)
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

-- 
	Balbir
