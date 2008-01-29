Return-Path: <linux-kernel-owner+w=401wt.eu-S1763515AbYA2FMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763515AbYA2FMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763180AbYA2FML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:12:11 -0500
Received: from mail.suse.de ([195.135.220.2]:44602 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762976AbYA2FMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:12:08 -0500
Date: Mon, 28 Jan 2008 21:15:33 -0800
From: Greg KH <gregkh@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Atari floppy: Rename disk_type to atari_disk_type
Message-ID: <20080129051533.GB2331@suse.de>
References: <Pine.LNX.4.64.0801271426590.8108@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801271426590.8108@anakin>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 02:28:35PM +0100, Geert Uytterhoeven wrote:
> Atari floppy: Rename disk_type to atari_disk_type
> 
> Commit edfaa7c36574f1bf09c65ad602412db9da5f96bf
> 
>     Driver core: convert block from raw kobjects to core devices
>     
>     This moves the block devices to /sys/class/block. It will create a
>     flat list of all block devices, with the disks and partitions in one
>     directory. For compatibility /sys/block is created and contains symlinks
>     to the disks.
> 
> introduced a global disk_type variable in <linux/genhd.h>, causing the
> following compile error on Atari:
> 
>     drivers/block/ataflop.c:93: error: conflicting types for 'disk_type'
>     include/linux/genhd.h:21: error: previous declaration of 'disk_type' was here
> 
> Rename the local disk_type variable in drivers/block/ataflop.c to
> atari_disk_type, to avoid the conflict.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

