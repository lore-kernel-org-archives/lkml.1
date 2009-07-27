Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZG0Ovf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZG0Ovf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZG0Ove
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:51:34 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:25950
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750851AbZG0Ovd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:51:33 -0400
Message-ID: <4A6DBEEB.5020302@panasas.com>
Date: Mon, 27 Jul 2009 17:51:23 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>,
       Tarkan Erimer <tarkan.erimer@turknet.net.tr>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>	<yq1hbwykj80.fsf@sermon.lab.mkp.net>	<20090727020611.GC3711@parisc-linux.org>	<yq18wiakfq4.fsf@sermon.lab.mkp.net> <4A6D64DC.3020001@panasas.com> <yq1ocr66vy6.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1ocr66vy6.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2009 14:51:26.0151 (UTC) FILETIME=[B7647570:01CA0EC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2009 05:29 PM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
> Boaz> I don't understand. The device in question breaks when we try to
> Boaz> read a page that it reported it supports?
> 
> No.  The USB-ATA bridge in question locks up when we send it an INQUIRY
> with EVPD=1.  I.e. when we try to get a list of pages. 0xB0 and 0xB1 are
> not even in play here.
> 

Haa, OK. I thought INQUIRY EVPD=1 page=0 was so old it sure must be supported
but you are saying it's only SBC2/SPC3. So I guess there is nothing else we can do.

What I hate about all this is that in USB the scsi_level is hard coded at the driver,
without actually been able to probe the device about it. So my 1 TeraByte new seagate
external disk must behave like the above junk.
(Thank god for eSATA)

Boaz
