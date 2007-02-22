Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXBVHLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXBVHLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXBVHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:11:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:10274 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXBVHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AYFLPzOcYvOciBrRY+MJBEIst/8HKem9pXj3TblcIemRoMEDo/9jclHc4AigQPI1SeFUajiR4QPEAW7u0pz3rm10FHeniyuUsack60NQVnhoqxyxsQJ4flr5u+yXZfZ4eZe0kg7dTke7jvf2qBPjSM1Z0DRFzq70yUzQbS9t6Ys=
Message-ID: <45DD420F.4000501@gmail.com>
Date: Thu, 22 Feb 2007 16:11:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, ceztko@gmail.com
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Fk9DulKIUBewV0V2B72MDzbelmU@ifi.uio.no> <fa.RCbhxyLCSR5f65HWabMGmxZNYQ4@ifi.uio.no> <fa.G4k+9fbJDE0N5pygu22mRYU6gfE@ifi.uio.no> <45DD37E9.7010303@shaw.ca>
In-Reply-To: <45DD37E9.7010303@shaw.ca>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Robert Hancock wrote:
>> Alan wrote:
>>> Stick some printk calls in drivers/ata/libata-eh.c in ata_eh_suspend, or
>>> turn on all the ATA debug and shutdown, the code should issue a cache
>>> flush followed by a standbynow1 command for each disk.
>>>
>>> Alan
>>
>> I believe it runs on suspend, but we don't run that code on normal
>> shutdown, do we?
>>
>> Tejun Heo had a patch for sd that could (optionally) trigger a START
>> STOP UNIT command to spin the disk down after synchronizing the cache
>> before shutdown, but I haven't heard anything of it lately..

I just came back from LSF and lunar new year's holidays and need a bit
more time to get to it.  I'll get to it in one or two weeks.

-- 
tejun
