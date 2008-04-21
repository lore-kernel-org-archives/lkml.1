Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYDUDUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYDUDUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 23:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYDUDUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 23:20:10 -0400
Received: from sandeen.net ([209.173.210.139]:20089 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbYDUDUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 23:20:09 -0400
Message-ID: <480C07E8.1070501@sandeen.net>
Date: Sun, 20 Apr 2008 22:20:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: g3vbv@blueyonder.co.uk
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 (swap)
 partitions on a SATA drive
References: <480A9C1E.8050505@blueyonder.co.uk>
In-Reply-To: <480A9C1E.8050505@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sid Boyce wrote:
> 2.6.25 x86_64 boots fine as does -git1/2 boxes using reiserfs and ext3. 
> With xfs it can't find these and drops into a shell.
> /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part2 swap 
>               swap       defaults              0 0
> /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 / 
>               xfs        defaults              1 1
> 
>  From my .config
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> 
> The other boxes are configure pretty much the same, but I can diff the 
> .config's if required.

Does it not find the device, or does it not find the filesystem?  What's
the relevant message?  Does it enumerate the partitions it finds, and is
your partition in the list?  Do you see the xfs module initialization
message go by before the error to indicate that it really did get loaded?

-Eric

