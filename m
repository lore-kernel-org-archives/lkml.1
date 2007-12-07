Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXLGAlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXLGAlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbXLGAku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:40:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753433AbXLGAks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:40:48 -0500
Date: Thu, 6 Dec 2007 16:40:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Tom Lanyon" <tomlanyon@gmail.com>
Subject: Re: Failure with SATA DVD-RW
Message-Id: <20071206164043.589290f4.akpm@linux-foundation.org>
In-Reply-To: <loom.20071206T012459-620@post.gmane.org>
References: <cd32a0620712041608o7733db74xf4975dec44925730@mail.gmail.com>
	<loom.20071206T012459-620@post.gmane.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(argh, shit, resent.  Please don't massage the cc list.  Do reply-to-all)

On Thu, 6 Dec 2007 01:33:16 +0000 (UTC)
Parag Warudkar <parag.warudkar@gmail.com> wrote:

> Tom Lanyon <tomlanyon <at> gmail.com> writes:
> 
> > scsi4: ahci
> > ata5: SATA link up at 1.5 Gbps (SStatus 113 SControl 300)
> > ata5.00: ATAPI, max UDMA/66
> > ata5.00: qc timeout (cmd 0xef)
> > ata5.00: failed to set xfermode (err_mask=0x104)
> > ata5.00: limiting speed to UDMA/44
> > ata5: failed to recover some devices, retrying in 5 secs
> > ata5: port is slow to respond, please be patient (Status 0x80)
> > ata5: port failed to respond (30 secs, status 0x80)
> > ata5: COMRESET failed (device not ready)
> > ata5: hardreset failed, retrying in 5 secs
> > ata5: SATA link up at 1.5 Gbps (SStatus 113 SControl 300)
> > ata5.00: ATAPI, max UDMA/66
> > ata5.00: qc timeout (cmd 0xef)
> > ata5.00: failed to set xfermode (err_mask=0x104)
> > ata5.00: limiting speed to PIO0
> > ata5: failed to recover some devices, retrying in 5 secs
> > ata5: port is slow to respond, please be patient (Status 0x80)
> > ata5: port failed to respond (30 secs, status 0x80)
> > ata5: COMRESET failed (device not ready)
> > ata5: hardreset failed, retrying in 5 secs
> > ata5.00: ATAPI, max UDMA/66
> > ata5.00: qc timeout (cmd 0xef)
> > ata5.00: failed to set xfermode (err_mask=0x104)
> > ata5.00: disabled
> > 
> Looks like it is trying to set transfer mode to UDMA/66 and failing. After 
> that it tried UDMA/44 and failed again. Next UDMA/66 again with unsurprising 
> result - failed. After that PIO0 which seems to cause some kind of trouble, 
> then it tries UDMA/66 again, and I am not stating the result again :) ! 
> 
> > Any ideas what to try to get it working under AHCI?
> > 
> 
> I recall reading somewhere - the Pioneer drive needs UDMA/33 which it did not 
> try in your case - need to some how have it try UDMA/33 but I don't find a 
> boot parameter which will do that. So may be adding a quirk for this device to 
> limit the xfer mode to 33 may work. 
> 
> What does your dmesg output for the drives look like when you run in IDE 
> compat mode? (Particularly the DMA for this drive?)
> 

Please cc linux-ide on sata, pata and ide-related issues.

If nothing happens within a few days please raise a report at
bugzilla.kernel.org so we can ignore this in an organised fashion, thanks.

