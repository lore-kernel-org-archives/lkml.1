Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbXEXWCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbXEXWCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXEXWCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:02:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:13364 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbXEXWCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ei1ndsaAC9NRLGK6qJbJK/YlahCBHQ/MER8jcIdJPdeJrj0CQl9UNxMd8od2vtWwe28eM2EpzoCYpvEBO5E0WDP6fse71UqRh3ILrrnUz4b8dKLNf6/rxctB/tulzrQLxHnGZa2R0Ft3RnJgcopwCx3re7HPwfaitrTCWRS5wlA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Pascal Schmidt" <pasukaru@yurusanai.de>
Subject: Re: HPT366 not enabled by kernel 2.6.21.2
Date: Fri, 25 May 2007 00:15:02 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <48969.80.228.60.226.1180041664.squirrel@yurusanai.de>
In-Reply-To: <48969.80.228.60.226.1180041664.squirrel@yurusanai.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705250015.02222.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding linux-ide ML and Sergei to cc: ]

Hi,

On Thursday 24 May 2007, Pascal Schmidt wrote:
> 
> Hello!
> 
> I recently upgraded my kernel to 2.6.21 (.1 and .2 with identical
> results) and my second IDE controller, a HPT366 on a PCI card,
> doesn't get enabled any more. The latest previous kernel I used was
> 2.6.19.7, where the HPT366 worked.
> 
> Here's the HPT366 part of the 2.6.21.2 dmesg:
> 
> HPT366: IDE controller at PCI slot 0000:02:0a.0
> ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
> HPT366: chipset revision 1
> HPT366: using 33 MHz PCI clock
> HPT366: 100% native mode on irq 18
> HPT366: neither IDE port enabled (BIOS)
> ACPI: PCI Interrupt 0000:02:0a.1[A] -> GSI 18 (level, low) -> IRQ 18
> HPT366: using 33 MHz PCI clock
> HPT366: neither IDE port enabled (BIOS)
> 
> There is a flash disk connected to the primary channel (master)
> which also shows up in the controller's BIOS screen, so I don't
> think it's true that both ports are disabled.
> 
> Under 2.6.17.9 the "neither IDE port enabled" message doesn't
> happen and hde gets detected.

The fix from Sergei (queued for 2.6.21.3) is here:

http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=queue-2.6.21/hpt366-don-t-check-enablebits-for-hpt36x.patch;h=0833e0a37e23ed103a18ca93684201e1cb94a0a9

[ it has already been merged into 2.6.22 tree ]

Thanks,
Bart
