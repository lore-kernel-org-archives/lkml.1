Return-Path: <linux-kernel-owner+w=401wt.eu-S1030646AbXBGR4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030646AbXBGR4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161416AbXBGR4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:56:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:37109 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161392AbXBGRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HwyG63bjGQzVW1PztEjn1bXLHf/RImMLsAp+C9g/yvMWnGpC5e7ytMzG6p4qi60cNXZumEf0EA0wU5jH7lSIfZskbGwonKJIg2Oq/I+d/fDBI8BGmE4gAVj9VF2EFy0QY7hIyEwheGxcAoLyrei5SGB5yGLaOtVBDH1gduqWaT8=
Message-ID: <45C9DC4E.7090901@gmail.com>
Date: Wed, 07 Feb 2007 06:03:58 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <45C0CBF7.9000206@sandeen.net> <45C0CCE3.6030008@garzik.org> <45C0CD52.3080908@sandeen.net>
In-Reply-To: <45C0CD52.3080908@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Jeff Garzik wrote:
>> Eric Sandeen wrote:
>>> Jeff Garzik wrote:
>>>> Roland Dreier wrote:
>>>>> And I seem to recall there's more SATA chipset documentation than Jeff
>>>>> Garzik has time to implement support for.
>>>> I seriously doubt you can come up with even a single concrete example here.
>>> Not trying to slight Jeff here in any way, but I thought I'd point out
>>> one driver-less SATA chip that seems to have docs available.
>>>
>>> When looking for a sata controller I came across several inexpensive
>>> ones based on an Initio chipset, and at first glance it seems that they
>>> have docs out there*: http://www.initio.com/products/sata.htm
>>>
>>> but no drivers yet.  Just in case anyone is interested :)
>> The driver is in libata-dev.git#upstream and queued for 2.6.21.
>>
>> 	Jeff
> 
> Woo!  that was fast.  Ok I stand corrected. :)

Be warned.  The driver is marked HIGHLY EXPERIMENTAL and it seem to work 
only on my machine.  Seems to have some problem with LBA48 support.

The datasheet initio posted on the website just contains register 
descriptions, which is much better than nothing but I still had to do a 
LOT of trial-and-error to make that thing quasi-working.  I've tried to 
contact them in many ways but couldn't get any response.  I'll probably 
get back to it in a few weeks.

I can write ATA drivers for most hardware in a few days given 1. 
actually useful datasheet 2. hardware at hand 3. an ENGINEER to talk to 
when I get stuck.  So, sign me up.

It will be nice to have some central web site / wiki / whatever to 
monitor progress, arbitrate jobs, provides link to relevant info and 
people (probably some of them being open-by-request) and possibly 
provide links to bugzilla entries.

-- 
tejun

