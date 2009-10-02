Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZJBOqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZJBOqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZJBOqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:46:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59067 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbZJBOqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:46:48 -0400
Message-ID: <4AC61259.5080704@garzik.org>
Date: Fri, 02 Oct 2009 10:46:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Shawn Starr <shawn.starr@rogers.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER  DVD-RW  DVR-111D
References: <200910012215.04621.shawn.starr@rogers.com>
In-Reply-To: <200910012215.04621.shawn.starr@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2009 10:15 PM, Shawn Starr wrote:
>
> Model is:
> Unable to burn DVDs with 2.6.31.x
>
> ata7.00: ATAPI: PIONEER DVD-RW  DVR-111D, 1.29, max UDMA/66
> scsi 6:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-111D 1.29 PQ: 0 ANSI: 5
>
> sr 6:0:0:0: [sr0] Unhandled sense code
> sr 6:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sr 6:0:0:0: [sr0] Sense Key : Medium Error [current]
> Info fld=0x0
> sr 6:0:0:0: [sr0] Add. Sense: L-EC uncorrectable error
> end_request: I/O error, dev sr0, sector 0
> Buffer I/O error on device sr0, logical block 0
>
> wodim (cdrecord):
>
> Errno: 5 (Input/output error), reserve track scsi sendcmd: no error
> CDB:  53 00 00 00 00 00 1D 60 3C 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 00 00 00
> Sense Key: 0x5 Illegal Request, Segment 0
> Sense Code: 0x21 Qual 0x00 (logical block address out of range) Fru 0x0
> Sense flags: Blk 0 (not valid)
> cmd finished after 0.006s timeout 40s
> wodim: Cannot open new session.
>
> I thought maybe this was due to something with kernel config but I'm not sure
> now. This used to work fine.
>
> Anyone also able to confirm something broke or if I'm enabling something in
> .config I shouldn't be?

Can you post full dmesg output?  And you have verified that vanilla 
2.6.30 kernel works OK?

	Jeff



