Return-Path: <linux-kernel-owner+w=401wt.eu-S1765973AbXHXXZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765973AbXHXXZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761683AbXHXXZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:25:12 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:22659 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbXHXXZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:25:10 -0400
Date: Fri, 24 Aug 2007 17:24:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [sata_nv] timeout waiting for ADMA IDLE, stat=0x440
In-reply-to: <fa.JryGluomV43EviuSMJKX+JI+tvU@ifi.uio.no>
To: Maarten Maathuis <madman2003@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46CF68C4.9040506@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.JryGluomV43EviuSMJKX+JI+tvU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Maathuis wrote:
> I have this problem several times, always with the same harddrive, a
> samsung sp2004c. My samsung hd161hj and hd321kj don't seem to suffer
> from this problem. I do not know when exactly it happened for the
> first, but it has happened twice on a 2.6.22 kernel.
> 
> Is there anything that can be done about this (besides disabling adma
> for all drives), or any information i can provide to help?
> 
> Please CC me, as i am not a member of this mailinglist.
> 
> Sincerely,
> 
> Maarten Maathuis.
> 
> dmesg snippet:
> 
> ata4: timeout waiting for ADMA IDLE, stat=0x440
> ata4.00: qc timeout (cmd 0x2f)
> ata4: failed to read log page 10h (errno=-5)
> ata4.00: exception Emask 0x1 SAct 0x1 SErr 0x380000 action 0x2 frozen
> ata4.00: (CPB resp_flags 0x11: CMD error)
> ata4.00: cmd 60/80:00:89:b0:30/00:00:02:00:00/40 tag 0 cdb 0x0 data 65536 in
>          res 51/84:00:02:00:00/84:00:02:00:00/40 Emask 0x10 (ATA bus error)

Sounds like the drive has gotten into a really hosed state after this 
point. The SError register is showing a CRC error, disparity error, and 
10b to 8b decode error, which indicates that there are some major SATA 
communication problems happening.

It could be a hardware problem (bad drive, bad SATA cable, insufficient 
power, etc.) or maybe this is another drive with broken NCQ..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

