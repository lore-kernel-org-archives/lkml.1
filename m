Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbXBWASx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbXBWASx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 19:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXBWASx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 19:18:53 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:12115 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXBWASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 19:18:52 -0500
Date: Thu, 22 Feb 2007 18:18:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image
 Windows driver
In-reply-to: <3A2F4CD2-EF4C-4C5D-B1B3-A9C89BA9682C@develooper.com>
To: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Tejun Heo <htejun@gmail.com>, "Eric D. Mudama" <edmudama@gmail.com>
Message-id: <45DE32E7.1010901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <45DD2EC9.4050403@shaw.ca> <45DD3EC7.3050801@garzik.org>
 <3A2F4CD2-EF4C-4C5D-B1B3-A9C89BA9682C@develooper.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ask Bjørn Hansen wrote:
> 
> On Feb 21, 2007, at 10:57 PM, Jeff Garzik wrote:
> 
>>> +    /* The following blacklist entries are taken from the Windows
>>> +       driver .inf files for the Silicon Image 3124 and 3132. */
>>> +    { "Maxtor 7B250S0",    "BANC1B70",    ATA_HORKAGE_NONCQ, },
> [...]
>>
>> Do we have information that these drives fail on non-SiI controllers?
> 
> At least tangentially related:
> 
> On one of my boxes (running 2.6.18-1.2869 from Fedora) I have a couple 
> of other Maxtor drives that didn't like NCQ.   They are on a JMicron 
> 20360/20363 (ahci driver).  (There's also a Promise 300 TX4 card in the 
> box and an Intel ICH8 that shows up with ata_piix).
> 
> model and (partial) firmware revision of the drives:
> Maxtor 7V300F0  VA11
> Maxtor 7B300S0  BANC
> 
> Until I disabled NCQ I got gazillions of messages like the ones below 
> and absymal performance.
> 
>   - ask
> 
> 
> ata5: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive 0xf)

Sounds like those are some that we should be blacklisting as well, 
unless Eric has a good reason why not (CCing). Can you provide the full 
firmware revision strings from those drives, i.e. from "hdparm -I"?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

