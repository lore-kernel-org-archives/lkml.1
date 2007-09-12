Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbXILND6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbXILND6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXILNDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:03:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51722 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXILNDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:03:50 -0400
Date: Wed, 12 Sep 2007 15:03:49 +0200
From: Jan Kara <jack@suse.cz>
To: Stef Epardaud <stef@epardaud.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Filesystem silent crash with EXT3
Message-ID: <20070912130349.GA19763@atrey.karlin.mff.cuni.cz>
References: <20070912120203.GA23510@inforealm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912120203.GA23510@inforealm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> I am not subscribed to this list, so please CC me on replies.
> I have just suffered from a filesystem crash on my laptop. It's an x86
> running linux 2.6.22 from Ubutu latest gutsy.
> This morning it booted and there were all kinds of strange core dumps.
> fsck told me the root filesystem was clean,.
> I then did a long test with smartctl which told me my disk was fine.
> Then I forced fsck to check the filesystem (I was getting lots of files
> not found), which then proceeded to fix plenty of errors, duplicate
> missing or shared inodes, and many other errors I did not understand.
> After pressing 'y' for about a hunderd times I was pretty convinced I
> would not get my data back. Anyways after the 'fix' several parts of my
> libc were removed and I cannot boot the system anymore (cannot get a
> shell).
  My condolations ;) Actually, smartctl is not very reliable... I've
heard about disks reporting everything is fine while they were broken.

> I had no idea my EXT3 filesystem could go wrong without notifying me
> (fsck thought the filesystem was clean before I forced it). Is this
> normal ?
> If not, what can I do to figure out what went wrong ?
> I am in the process of getting a live linux CD to look at the disk,
> maybe there are some logs that can help.
> Note that it's the first time I've lost a EXT3 (or EXT2) filesystem
> without having experienced any system crash or power failure to explain
> the filesystem problem. This machine booted and was turned off properly
> for several weeks (at least).
> Thanks for any help identifying the problem, I really hope this does not
> happen again to me or anyone else.
  It is close to impossible to find out what has happened after the fact
- I guess you don't have the original filesystem image backed-up, do
you? If something like this happens to you next time, try backing up
the filesystem image (via dd) before you run fsck (or if you don't have
enough spare space, you can use e2image to backup at least metadata).
Maybe if you could dig some messages in the system log, it would be
possible to find out what has happened. But with the information we
currently have it's to foggy to be able to debug anything... sorry.

							Honza
