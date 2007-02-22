Return-Path: <linux-kernel-owner+w=401wt.eu-S933086AbXBVPLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbXBVPLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933098AbXBVPLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:11:42 -0500
Received: from x8.develooper.com ([216.52.237.208]:45996 "EHLO
	x8.develooper.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086AbXBVPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:11:41 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 10:11:41 EST
In-Reply-To: <45DD3EC7.3050801@garzik.org>
References: <45DD2EC9.4050403@shaw.ca> <45DD3EC7.3050801@garzik.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3A2F4CD2-EF4C-4C5D-B1B3-A9C89BA9682C@develooper.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Tejun Heo <htejun@gmail.com>
Content-Transfer-Encoding: 7bit
From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image Windows driver
Date: Thu, 22 Feb 2007 07:04:58 -0800
To: Jeff Garzik <jeff@garzik.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 21, 2007, at 10:57 PM, Jeff Garzik wrote:

>> +    /* The following blacklist entries are taken from the Windows
>> +       driver .inf files for the Silicon Image 3124 and 3132. */
>> +    { "Maxtor 7B250S0",    "BANC1B70",    ATA_HORKAGE_NONCQ, },
[...]
>
> Do we have information that these drives fail on non-SiI controllers?

At least tangentially related:

On one of my boxes (running 2.6.18-1.2869 from Fedora) I have a  
couple of other Maxtor drives that didn't like NCQ.   They are on a  
JMicron 20360/20363 (ahci driver).  (There's also a Promise 300 TX4  
card in the box and an Intel ICH8 that shows up with ata_piix).

model and (partial) firmware revision of the drives:
Maxtor 7V300F0  VA11
Maxtor 7B300S0  BANC

Until I disabled NCQ I got gazillions of messages like the ones below  
and absymal performance.

   - ask


ata5: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive 0xf)
ata6: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive  
0x33)
ata5: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive 0x0)
ata6: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive 0x0)
ata5: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive 0x0)
ata6: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive 0x0)
ata6: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive  
0x38)
ata5: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive  
0x3c)
ata5: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive  
0xf2)
ata5: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive  
0x1c)



-- 
http://develooper.com/ - http://askask.com/


