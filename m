Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYC2FdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYC2FdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 01:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYC2FdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 01:33:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbYC2FdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 01:33:13 -0400
Date: Fri, 28 Mar 2008 22:33:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd/jbd2 NULL noise
Message-Id: <20080328223310.9a677e70.akpm@linux-foundation.org>
In-Reply-To: <20080329045634.GM10722@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk>
	<1206760526.6543.0.camel@brick>
	<20080329031843.GJ10722@ZenIV.linux.org.uk>
	<1206761196.6543.2.camel@brick>
	<20080329034228.GK10722@ZenIV.linux.org.uk>
	<20080329035431.GL10722@ZenIV.linux.org.uk>
	<1206763312.6543.4.camel@brick>
	<20080329045634.GM10722@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008 04:56:34 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Mar 28, 2008 at 09:01:52PM -0700, Harvey Harrison wrote:
> > > > > I did, it went into -mm and on Mar 5 it was taken into the subsystem
> > > 
> > > Al, still morbidly curious about the akpm's scripts and aforementioned
> > > message...
> > 
> > Not sure which tree, but received this on Feb 27:
> > 
> > 
> > The patch titled
> >      jbd2: sparse warnings in revoke.c, journal.c
> > has been removed from the -mm tree.  Its filename was
> >      jbd2-sparse-warnings-in-revokec-journalc.patch
> > 
> > This patch was dropped because it was merged into mainline or a
> > subsystem tree
> > 
> > The current -mm tree may be found at
> > http://userweb.kernel.org/~akpm/mmotm/
> 
> Ah...  jbd part of it is still there, jbd2 is *also* there, but it's got
> ext4-mm- prefix to filename.  And looking at ext4.git, jbd2 side of that
> stuff *is* merged, so what the hell is it doing in a separate file?
> Looks like -mm has ext4 stuff not as a single patch (like it does for
> many other git trees) but split into individual changesets for some
> reason...
> 

Yup, -mm consists of

- 71 git trees (origin.patch plus 70 git-foo.patch) (some may be empty)

  - The URL for each of these can be obtained from the first line of
    git-foo.patch, in http://userweb.kernel.org/~akpm/mmotm/

- Nine quilt trees, pulled from various opendirs

  Sekkrit locations:

http://ozlabs.org/~rusty/kernel/rr-latest
http://www.kernel.org/pub/linux/kernel/people/kristen/pci-hotplug
ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver-core
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-03-usb
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-pci
http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/
ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/

- squillions of other patches which are only in -mm.


Interesting factoid: -mm's series file was started on 1 Dec 2002 and is at
its 16,231st revision.  I'm surprised it hasn't worn out.

