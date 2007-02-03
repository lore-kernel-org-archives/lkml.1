Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbXBCTQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbXBCTQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 14:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXBCTQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 14:16:41 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:35033 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbXBCTQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 14:16:41 -0500
Date: Sat, 03 Feb 2007 13:14:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: hdparm for lib_pata
In-reply-to: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>
To: Patrick Ale <patrick.ale@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <45C4DF2A.1070501@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi guys,
> 
> Me again, sorry.
> 
> Is it possible to make hdparm work with libata?
> I have some drives that for some reason fall back to lower UDMA
> settings (like UDMA/44) while the drive is UDMA/100. I blame the way I
> set-up my raid arrays for this and the bus not being able to handle
> all the data that goes trough it but that isnt really the case now.
> 
> Anyway, I used to be able to force the drive back with using hdparm
> -X68 -d 1 /dev/sdk
> But with the new lib_pata drivers I get "Inappropriate iotcl for
> device" and HD_IO_DRIVE_CMD Input/Output errors.
> 
> Or! Is there some other way to force the drive not to failback to
> lower UDMA settings? (Yep, I know, if this is answer, it's my risk, I
> cant and wont blame you for destructing my pr0n or severe trauma I
> suffer from losing data)

Only some of the hdparm functionality is supported in libata, which is 
partially by design. Presently there's no way to override the DMA 
settings in libata, it starts out at the fastest supported settings and 
falls back if it gets too many errors of certain types.

You shouldn't be seeing errors like this unless you have bad IDE cables 
or are using 40-wire cables with high UDMA modes. Can you post the 
output you're seeing?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

