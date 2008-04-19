Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYDSHFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYDSHFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 03:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYDSHFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 03:05:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47816 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYDSHFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 03:05:04 -0400
Message-ID: <48099999.30400@garzik.org>
Date: Sat, 19 Apr 2008 03:04:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-mm1 -- Is this just my drive dying?
References: <a44ae5cd0804182217y1f94cceeq12115c379de7c58a@mail.gmail.com>
In-Reply-To: <a44ae5cd0804182217y1f94cceeq12115c379de7c58a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> [ 6288.201390] ata1.00: configured for UDMA/100
> [ 6288.201428] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE,SUGGEST_OK
> [ 6288.201435] sd 0:0:0:0: [sda] Sense Key : Medium Error [current] [descriptor]
> [ 6288.201445] Descriptor sense data with sense descriptors (in hex):
> [ 6288.201449]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [ 6288.201471]         00 94 45 27
> [ 6288.201480] sd 0:0:0:0: [sda] Add. Sense: Unrecovered read error -
> auto reallocate failed
> [ 6288.201489] end_request: I/O error, dev sda, sector 9717031
> [ 6288.201497] Buffer I/O error on device sda1, logical block 1214621
> [ 6288.203810] ata1: EH complete
> [ 6288.203921] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
> [ 6288.203973] sd 0:0:0:0: [sda] Write Protect is off
> [ 6288.203979] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 6288.205413] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [ 6288.275427] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
> [ 6288.283499] sd 0:0:0:0: [sda] Write Protect is off
> [ 6288.283511] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 6288.300123] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [ 6293.184073] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [ 6293.184084] ata1.00: BMDMA stat 0x65
> [ 6293.184093] ata1.00: cmd c8/00:08:27:45:94/00:00:00:00:00/e0 tag 0
> dma 4096 in
> [ 6293.184096]          res 51/40:08:27:45:94/00:00:00:00:00/e0 Emask
> 0x9 (media error)
> [ 6293.184102] ata1.00: status: { DRDY ERR }
> [ 6293.184105] ata1.00: error: { UNC }
> [ 6293.437665] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f,
> BIOS=0x3f000 (0xc600c0c0) ACPI=0x3f01f (20:600:0x13)

Yeah...   media error is straight from the drive itself.

	Jeff



