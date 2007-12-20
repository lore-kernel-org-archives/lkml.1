Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbXLTBMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbXLTBMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbXLTBLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:11:53 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:37806 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184AbXLTBLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:11:50 -0500
Date: Wed, 19 Dec 2007 19:09:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
In-reply-to: <fa.Xv3BmMxnCGLOeEijySte5mKDO5k@ifi.uio.no>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Jean Delvare <khali@linux-fr.org>,
       Shaohua Li <shaohua.li@intel.com>, Mike Houston <mikeserv@bmts.com>,
       Adrian Bunk <bunk@stusta.de>, Elvis Pranskevichus <el@prans.net>,
       mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, Adam Belay <ambx1@neo.rr.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Message-id: <4769C0E2.4000500@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QPUBl9Xd2PDsImgWn6hbR+ShV1U@ifi.uio.no>
 <fa.ri5Klmu4+MwjYC8x5nSms+xKXfI@ifi.uio.no>
 <fa.B/J+j9kGGZ1+gW9FrfHky+cj0Eo@ifi.uio.no>
 <fa.Xv3BmMxnCGLOeEijySte5mKDO5k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Corbacho wrote:
> On Thursday 20 December 2007 00:20:21 Bjorn Helgaas wrote:
>> I suspect the manufacturers would say "Oh, the sensors?  The BIOS
>> isn't broken, you're just supposed to use WMI or some (undocumented)
>> ACPI device to get at those."
> 
> It's quite possible - can we have DSDTs for the boards in question so we can 
> quickly check if this is a possibility? (Basically, to see if they have 
> PNP0C14 devices - if they don't, then I'm afraid it's nothing to do with 
> WMI).
> 
> -Carlos

It's quite possible that the BIOS accesses the device either from ACPI 
AML or possibly even from SMI. In that case it would be quite reasonable 
for the BIOS to reserve that region to prevent another driver from 
loading and trying to take conflicting control of the device. One has to 
be careful before assuming that any such reservation is bogus.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

