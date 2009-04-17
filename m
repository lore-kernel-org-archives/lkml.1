Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZDQBoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZDQBoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZDQBoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:44:34 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52335 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753679AbZDQBod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:44:33 -0400
Date: Fri, 17 Apr 2009 10:44:32 +0900 (JST)
Message-Id: <20090417.104432.193700511.ryov@valinux.co.jp>
To: akpm@linux-foundation.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, axboe@kernel.dk, baramsori72@gmail.com,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090416174428.6bb5da21.akpm@linux-foundation.org>
References: <20090416152937.b2188370.akpm@linux-foundation.org>
	<20090417092040.1c832c69.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416174428.6bb5da21.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/9] bio-cgroup controller
Date: Thu, 16 Apr 2009 17:44:28 -0700

> On Fri, 17 Apr 2009 09:20:40 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 16 Apr 2009 15:29:37 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Tue, 14 Apr 2009 22:21:14 +0200
> > > Andrea Righi <righi.andrea@gmail.com> wrote:
> > > 
> > > > Subject: [PATCH 3/9] bio-cgroup controller
> > > 
> > > Sorry, but I have to register extreme distress at the name of this. 
> > > The term "bio" is well-established in the kernel and here we have a new
> > > definition for the same term: "block I/O".
> > > 
> > > "bio" was a fine term for you to have chosen from the user's
> > > perspective, but from the kernel developer perspective it is quite
> > > horrid.  The patch adds a vast number of new symbols all into the
> > > existing "bio_" namespace, many of which aren't related to `struct bio'
> > > at all.
> > > 
> > > At least, I think that's what's happening.  Perhaps the controller
> > > really _is_ designed to track `struct bio'?  If so, that's an odd thing
> > > to tell userspace about.
> > > 
> > Hmm, how about iotrack-cgroup ?
> > 
> 
> Well. blockio_cgroup has the same character count and is more specific.

How about blkio_cgroup ?

Thanks,
Ryo Tsuruta
