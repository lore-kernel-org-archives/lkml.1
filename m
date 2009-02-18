Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZBRSdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZBRSdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZBRScv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:32:51 -0500
Received: from mail.tpi.com ([70.99.223.143]:1845 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbZBRScu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:32:50 -0500
X-Greylist: delayed 1312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 13:32:50 EST
Message-ID: <499C4F1E.8050901@canonical.com>
Date: Wed, 18 Feb 2009 11:10:38 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: tytso@mit.edu
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Ubuntu Jaunty ext3 --> ext4 upgrade issue
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted,

I've encountered a situation where the patches that you've proposed for
stable updates might be causing some issues. This user ivoks appears to
have an upgrade issue. I assume he's enabled ext4 on an existing ext3
file system. Hopefully I can get more details. Have you seen anything
like this?

After looking at your for-stable branch, I think I'm missing a couple of
jbd2 patches. Could they be significant?

rtg

<ivoks> i'm getting 'Invalid or unsupported executable format' from grub
on all jaunty's generic kernels since (including) 2.6.28-7
<rtg> ivoks: you must have HW issues. Surely lots of folks would have
been howling by now.
<ivoks> could be... but -6 works :/
<ivoks> even after reinstall of all kernels
<rtg> have you fsck'd ?
<ivoks> could try that...
 it's ext4
<rtg> ivoks: is it an ext4 upgrade, or was it install time formatted ?
<ivoks> upgrade
<rtg> hmm, there were a bunch of ext4 changes that went into -7.18
<ivoks> right, i've noticed that
<rtg> ivoks: any change you could build a kernel with all of those
patches reverted? I expected them via stable updates by now, but perhaps
Ted has been finding issues with them.
<ivoks> i could try...
<rtg> ivoks: they are all labeled 'SAUCE: (revert before 2.6.28.y
update) ext4:'
<ivoks> thanks
<ivoks> only 21 commits :)
<ivoks> is it possible to build i386 kernel on amd64?
<rtg> ivoks: you have to chroot the build.
<ivoks> oh, right!
<ivoks> rtg: so, reverting all ext4 commits since -6 did the trick
<rtg> ivoks: can you file a bug with the specifics, and your results
that I can pass on to Ted ?
<ivoks> yes, but later... i have to rush now :/
 take care
-- 
Tim Gardner tim.gardner@canonical.com
