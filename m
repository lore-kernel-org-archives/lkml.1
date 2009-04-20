Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZDTOse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZDTOse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZDTOsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:48:24 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45970 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZDTOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:48:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mjSKDM7Zu5LHNXbArU2KDAbL22Rcve9VQ6vDfXGmcfDr2BTRrqFAZEnsU/N0SkQDxj
         KWeIzAnKyC0wMdTz7CbfL7iRBuNxchC2G7dHHobTb4sEZHvB468qyCBA0YzBe8OmCgMG
         fOor8lSNPhQ0Y3fkvSVl3fYMQF0gXnVrBJaSo=
Date: Mon, 20 Apr 2009 16:48:17 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] cgroup: io-throttle controller (v14)
Message-ID: <20090420144816.GA13307@linux>
Mail-Followup-To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
	Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
	baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
	dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
	eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
	Hirokazu Takahashi <taka@valinux.co.jp>,
	Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
	fchecconi@gmail.com, paolo.valente@unimore.it,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1240090636-898-1-git-send-email-righi.andrea@gmail.com> <49EC34C1.6010709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC34C1.6010709@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 04:39:29PM +0800, Gui Jianfeng wrote:
> Andrea Righi wrote:
> ...
> > 
> > Implementation
> > ~~~~~~~~~~~~~~
> > Patchset against latest Linus' git:
> > 
> >   [PATCH 0/7] cgroup: block device IO controller (v14)
> >   [PATCH 1/7] io-throttle documentation
> >   [PATCH 2/7] res_counter: introduce ratelimiting attributes
> >   [PATCH 3/7] page_cgroup: provide a generic page tracking infrastructure
> >   [PATCH 4/7] io-throttle controller infrastructure
> >   [PATCH 5/7] kiothrottled: throttle buffered (writeback) IO
> >   [PATCH 6/7] io-throttle instrumentation
> >   [PATCH 7/7] export per-task io-throttle statistics to userspace
> 
>   Hi Andrea,
> 
>   I'd like to have a try this patchset, would you tell what's the kernel version
>   and bio-cgroup version based on?
> 

Latest Linus' git is the kernel and bio-cgroup v7 (from
http://people.valinux.co.jp/~ryov/bio-cgroup/).

Thanks!
-Andrea
