Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXBLOEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXBLOEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 09:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964933AbXBLOEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 09:04:12 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:60549 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbXBLOEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 09:04:11 -0500
To: szaka@sienet.hu
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.21.0702121259540.25964-100000@mlf.linux.rulez.org>
	(message from Szakacsits Szabolcs on Mon, 12 Feb 2007 13:39:39 +0100
	(MET))
Subject: Re: [RFC PATCH] add filesystem subtype support
References: <Pine.LNX.4.21.0702121259540.25964-100000@mlf.linux.rulez.org>
Message-Id: <E1HGbmc-0003oc-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Feb 2007 15:03:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > There's a slight problem with filesystem type representation in fuse
> > based filesystems.
> > 
> > >From the kernel's view, there are just two filesystem types: fuse and
> > fuseblk.  From the user's view there are lots of different filesystem
> > types.  The user is not even much concerned if the filesystem is fuse
> > based or not.  
> 
> Yes. Those who are concerned with the fstype and mount like
> 
>     mount -t fstype device mountpoint
> 
> apparently expect mount/fstab line like
> 
>     device mountpoint fstype ...

The problem with supporting 

  /dev/hda1   /mnt/windows   ntfs-3g   rw,...

type syntax in /proc/mounts is that it would add much more complexity
to the kernel.  The same could be achieved in userspace by teaching
the mount utility about special filesystems like ntfs-3g.

This patch aims for the minium footprint for a feature, that really
doesn't concern the kernel at all.

Miklos
