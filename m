Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXIEXD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXIEXD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 19:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbXIEXDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 19:03:46 -0400
Received: from rtr.ca ([76.10.145.34]:3635 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257AbXIEXDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 19:03:45 -0400
Message-ID: <46DF35CE.7090005@rtr.ca>
Date: Wed, 05 Sep 2007 19:03:42 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: htejun@gmail.com, michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com>	<20070905095327.6277d054.akpm@linux-foundation.org>	<46DEE617.4050004@rtr.ca> <20070905123851.a89b24b6.akpm@linux-foundation.org>
In-Reply-To: <20070905123851.a89b24b6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>..
> Hey, we just found something which doesn't crash my Vaio!
> 
> sony:/home/akpm/hdparm-7.7> 0 ./hdparm --drq-hsm-error /dev/sda
> 
> /dev/sda:
>  triggering "stuck DRQ" host state machine error
> do_drq_hsm_error: Success
> ata status=0x58 ata error=0x00
> 
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata3.00: cmd ec/00:00:00:00:00/00:00:00:00:00/40 tag 0 cdb 0x0 data 0 
>          res 58/00:01:00:00:00/00:00:00:00:00/40 Emask 0x2 (HSM violation)
> ata3: soft resetting port
> ata3.00: configured for UDMA/100
> ata3: EH complete
> sd 2:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> How dull. (ata_piix)

:)

On my two very similar notebooks, it crashes libata when a PATA drive is used
behind a Marvell converter chip, but not when a SATA drive is used directly.

Cheers
