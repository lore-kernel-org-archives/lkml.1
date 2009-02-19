Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZBSJnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZBSJnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZBSJnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:43:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:53220 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753959AbZBSJnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:43:08 -0500
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18/TS1FXLg/9YnpLKjKTKdDoRbcZ9/CuPOlRPgkw8
	AF94f4K2K5P6OA
From: Marvin <marvin24@gmx.de>
To: tim.gardner@canonical.com
Subject: Re: Ubuntu Jaunty ext3 --> ext4 upgrade issue
Date: Thu, 19 Feb 2009 10:43:02 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.27-11-generic; KDE/4.1.4; x86_64; ; )
Cc: tytso@mit.edu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <499C4F1E.8050901@canonical.com>
In-Reply-To: <499C4F1E.8050901@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191043.02880.marvin24@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tim,

Am Mittwoch 18 Februar 2009 19:10:38 schrieb Tim Gardner:
> Ted,
>
> I've encountered a situation where the patches that you've proposed for
> stable updates might be causing some issues. This user ivoks appears to
> have an upgrade issue. I assume he's enabled ext4 on an existing ext3
> file system. Hopefully I can get more details. Have you seen anything
> like this?

I had a similar issue with intrepid. To be able to boot from the ext4 fs, I 
installed grub2 from jaunty. The error went away after compiling grub2 from 
source and coping only the ext2.mod to the grub dir. So there must be some 
later updates missing. I guess this is some fallout from 2.6.27/TESTFS or 
similar.

Marvin

> After looking at your for-stable branch, I think I'm missing a couple of
> jbd2 patches. Could they be significant?
>
> rtg
>
> <ivoks> i'm getting 'Invalid or unsupported executable format' from grub
> on all jaunty's generic kernels since (including) 2.6.28-7
> <rtg> ivoks: you must have HW issues. Surely lots of folks would have
> been howling by now.
> <ivoks> could be... but -6 works :/
> <ivoks> even after reinstall of all kernels
> <rtg> have you fsck'd ?
> <ivoks> could try that...
>  it's ext4
> <rtg> ivoks: is it an ext4 upgrade, or was it install time formatted ?
> <ivoks> upgrade
> <rtg> hmm, there were a bunch of ext4 changes that went into -7.18
> <ivoks> right, i've noticed that
> <rtg> ivoks: any change you could build a kernel with all of those
> patches reverted? I expected them via stable updates by now, but perhaps
> Ted has been finding issues with them.
> <ivoks> i could try...
> <rtg> ivoks: they are all labeled 'SAUCE: (revert before 2.6.28.y
> update) ext4:'
> <ivoks> thanks
> <ivoks> only 21 commits :)
> <ivoks> is it possible to build i386 kernel on amd64?
> <rtg> ivoks: you have to chroot the build.
> <ivoks> oh, right!
> <ivoks> rtg: so, reverting all ext4 commits since -6 did the trick
> <rtg> ivoks: can you file a bug with the specifics, and your results
> that I can pass on to Ted ?
> <ivoks> yes, but later... i have to rush now :/
>  take care

