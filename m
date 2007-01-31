Return-Path: <linux-kernel-owner+w=401wt.eu-S965017AbXAaPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017AbXAaPK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965007AbXAaPK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:10:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57566 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964976AbXAaPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:10:57 -0500
Date: Wed, 31 Jan 2007 15:23:01 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <liml@rtr.ca>
Cc: Ric Wheeler <ric@emc.com>, "Eric D. Mudama" <edmudama@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Message-ID: <20070131152301.19a8a5ac@localhost.localdomain>
In-Reply-To: <45C0B0DC.8030501@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>
	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	<311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>
	<45BFF3D6.9050605@rtr.ca>
	<45C00AEE.1090708@emc.com>
	<45C0B0DC.8030501@rtr.ca>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> When libata reports a MEDIUM_ERROR to us, we *know* it's non-recoverable,
> as the drive itself has already done internal retries (libata uses the
> "with retry" ATA opcodes for this).

This depends on the firmware. Some of the "raid firmware" drives don't
appear to do retries in firmware.

> But meanwhile, we still have the original issue too, where a single stray
> bad sector can blow a system out of the water, because the mid-layer
> currently aborts everything after it from a large merged request.
> 
> Thus the original patch from this thread.  :)

Agreed
