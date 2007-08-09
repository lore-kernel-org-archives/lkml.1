Return-Path: <linux-kernel-owner+w=401wt.eu-S940554AbXHIOxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940554AbXHIOxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935348AbXHIOxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:53:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58331 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935298AbXHIOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:53:15 -0400
Message-ID: <46BB2A49.5090503@oracle.com>
Date: Thu, 09 Aug 2007 10:52:57 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture, Linux Projects Group
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: DMA CRC errors with SiS chipset and notebook drive
References: <46BB190E.2030102@oracle.com> <20070809155324.3a9499ca@the-village.bc.nu>
In-Reply-To: <20070809155324.3a9499ca@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------050500080300090103030201"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050500080300090103030201
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit



Alan Cox wrote:
>> Aug  9 07:41:29 monet kernel: ata1.00: limiting speed to UDMA/66:PIO4
>> Aug  9 07:41:29 monet kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr
>> 0x0 action 0x2
>> Aug  9 07:41:29 monet kernel: ata1.00: (BMDMA stat 0x64)
>> Aug  9 07:41:29 monet kernel: ata1.00: cmd
>> c8/00:08:fb:7c:a1/00:00:00:00:00/e0 tag 0 cdb 0x12 data 4096 in
>> Aug  9 07:41:29 monet kernel:          res
>> 51/84:00:00:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
>> Aug  9 07:41:29 monet kernel: ata1: soft resetting port
>> Aug  9 07:41:29 monet kernel: ata1.00: configured for UDMA/66
>> Aug  9 07:41:29 monet kernel: ata1.01: configured for UDMA/33
>> Aug  9 07:41:29 monet kernel: ata1: EH complete
> 
> Drops to UDMA33 for 40 wire cable.

It drops from UDMA/100 to UDMA/66 for the disk, but stays at UDMA/33 for 
the optical drive.  If I have only the disk on that controller, the disk 
still drops to UDMA/66.

> Looks to me like your cabling is out of spec or you have electrical noise
> problems.

I've tried different cabling solutions, including round and flat IDE 
cables.  What might cause "electrical noise"?  Are 44-40 pin adapters 
reliable?

--------------050500080300090103030201
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel
version:2.1
end:vcard


--------------050500080300090103030201--
