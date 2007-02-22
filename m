Return-Path: <linux-kernel-owner+w=401wt.eu-S1750866AbXBVCne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866AbXBVCne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbXBVCne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:43:34 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:40980 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbXBVCnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:43:33 -0500
Date: Wed, 21 Feb 2007 20:43:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
In-reply-to: <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no>
To: Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Francesco Pretto <ceztko@gmail.com>, Tejun Heo <htejun@gmail.com>
Message-id: <45DD0348.5040005@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>
 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Stick some printk calls in drivers/ata/libata-eh.c in ata_eh_suspend, or
> turn on all the ATA debug and shutdown, the code should issue a cache
> flush followed by a standbynow1 command for each disk.
> 
> Alan

I believe it runs on suspend, but we don't run that code on normal 
shutdown, do we?

Tejun Heo had a patch for sd that could (optionally) trigger a START 
STOP UNIT command to spin the disk down after synchronizing the cache 
before shutdown, but I haven't heard anything of it lately..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

