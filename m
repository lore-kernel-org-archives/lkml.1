Return-Path: <linux-kernel-owner+w=401wt.eu-S1422675AbXCBBVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422675AbXCBBVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 20:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422676AbXCBBVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 20:21:05 -0500
Received: from mcr-smtp-002.bulldogdsl.com ([212.158.248.8]:4640 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422675AbXCBBVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 20:21:04 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: CK804 SATA Errors (still got them)
Date: Fri, 2 Mar 2007 01:20:52 +0000
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <200703011339.52895.s0348365@sms.ed.ac.uk> <45E6E701.6000600@shaw.ca> <200703011513.15179.s0348365@sms.ed.ac.uk>
In-Reply-To: <200703011513.15179.s0348365@sms.ed.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703020120.52879.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 15:13, Alistair John Strachan wrote:
> On Thursday 01 March 2007 14:45, Robert Hancock wrote:
> > This one seems a bit different. This time it's not related to NCQ vs.
> > non-NCQ (this is a non-NCQ write here), it's in ADMA mode (so it's
> > presumably not related to switching between ADMA and register mode,
> > unless perhaps a flush cache or something executed just before), and
> > from the CPB data it appears the command completed but the controller's
> > registers aren't indicating that it has. Not sure if I've seen one like
> > that before..
> >
> > How easily can you reproduce this?
>
> It's the first one since -rc2, so apparently not easily. I'm more than
> willing to find loads that expose it, though, so I might try that this
> afternoon.

Got another:

ata2: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x500 next cpb count 0x0 next cpb idx 0x0
ata2: CPB 0: ctl_flags 0xd, resp_flags 0x1
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd c8/00:80:85:c4:ed/00:00:00:00:00/e3 tag 0 cdb 0x0 data 65536 in
         res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Different HD, similar problem.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
