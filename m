Return-Path: <linux-kernel-owner+w=401wt.eu-S1161524AbXBHEio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161524AbXBHEio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 23:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161525AbXBHEio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 23:38:44 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:37183 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161524AbXBHEin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 23:38:43 -0500
Date: Wed, 07 Feb 2007 22:36:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [BUG?] ata disk running maximum at DMA33 with 2.6.20 and new pata
 driver, NV CK804 ide controller.
In-reply-to: <fa.Bv1nbk8Z669RxoYF6zPFpsCsyd4@ifi.uio.no>
To: Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Luigi Genoni <genoni@sns.it>
Message-id: <45CAA8EA.2010505@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.xQT7YaGQERXkjuW4tC35jsdiTD0@ifi.uio.no>
 <fa.Bv1nbk8Z669RxoYF6zPFpsCsyd4@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> On Wed, 7 Feb 2007 01:19:36 +0100
> Luigi Genoni <genoni@sns.it> wrote:
> 
>> Hi,
>> since upgrading to kernel 2.6.20 my pata disk, using new pata driver, is
>> initialized maximum  in DMA33 mode (and obviously performances drop 
>> consequently), as you can see from:
> 
> Interesting.
> 
>> Willing to test any patch.
> 
> Firstly can you see if its consistently the case that booting 2.6.20
> gives UDMA33 and 2.6.19 UDMA100 over a few reboots. If it is please drop
> the 2.6.19 drivers/ata/pamd_amd into 2.6.20 and try that.

As an aside to this sort of problem, shouldn't we print some kind of 
loud message in dmesg when we force a high-UDMA-capable device down to 
UDMA33 due to a 40-wire cable detection? In the case where it truly is a 
40-wire cable the user may want to know that and replace the cable, if 
it isn't it gives more of a hint of why the drive isn't running at full 
speed..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

