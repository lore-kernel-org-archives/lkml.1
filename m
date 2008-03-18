Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbYCSUzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbYCSUzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbYCSTtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:49:18 -0400
Received: from emulex.emulex.com ([138.239.112.1]:50065 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759399AbYCSTtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:49:16 -0400
Message-ID: <47E0312C.3040805@emulex.com>
Date: Tue, 18 Mar 2008 17:16:28 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: lkml@foss.daxal.com
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fibre channel network interfaces + Linux SAN
References: <47E01DB3.90307@emulex.com>
In-Reply-To: <47E01DB3.90307@emulex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2008 21:16:29.0126 (UTC) FILETIME=[54F2AE60:01C8893D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott,

Re: IP networking on FC
It is possible, and Emulex has had product in the past for this. However, we've
never had enough interest to warrant the work needed to get it up on 2.6.
In general, there's very little interest in it anymore.

Re: LVM on FC
The LVM on FC scsi disks should be normal. The more interesting part is the boot
part. Boot support means getting the expansion rom driver configured properly
(whether that be BIOS, EFI, or OpenBoot). If you go to the Emulex support/download
page, and look for firmware for your adapter, there is documentation on the setting
boot devices, etc. You will need to be careful that the disk is either used on its
own or as a mirror, it can't be used as a raid set.  Further boot specifics should
defer to grub (or your favorite boot loader) and LVM.  Outside the expansion rom
driver setup, the fact that it's FC should not matter, and it should look like a
normal scsi disk.   And now the bad news... the LP8000 is rather old, it may be EOL'd,
so you may not find the latest boot firmware, and you would be stuck with whatever
is on the adapter, or find a newer one.


-- james s




Scott Edwards wrote:
> Two things I'm trying to solve with my fc hardware.  How do I enable these
> for IP networking, and how do I offer say lvm logical volumes behind Linux
> as a SAN? I'd like nodes to be bootable and offer specific volumes as their
> disks.  I'm using 2.6.28

