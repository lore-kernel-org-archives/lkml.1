Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbXL0SCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbXL0SCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbXL0SBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:01:54 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6494 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbXL0SBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:01:38 -0500
Date: Thu, 27 Dec 2007 11:59:23 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-reply-to: <fa.gv3MUHxQvd7EaG/0hhC9IzBvIlA@ifi.uio.no>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Message-id: <4773E7FB.2020000@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>
 <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>
 <fa.gv3MUHxQvd7EaG/0hhC9IzBvIlA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> 2) [non-minor] hmmmm.
>>
>> 	[jgarzik@core ~]$ lspci -n | wc -l
>> 	23
>>
>> So I would have to perform 23 sysfs twiddles, before I could obtain a 
>> full and unabridged 'lspci -vvvxxx'?
> 
> not you as human, but "lspci" ought to yes.
> 
>> For the userspace interface, the most-often-used knob for diagnostic 
>> purposes will be the easiest one.  And that's
> 
> the easiest one is an option to lspci. Nothing more nothing less.
> 
> Making a global knob in kernel space is a lot more tricky, and in addition
> really there's enough cases where userspace wants the one device anyway
> Doing the "for each device I'm about to dump" in lspci is pretty much as hard as doing
> the global one (if not simpler)

So then if you have a system where MMCONFIG doesn't work and you're not 
using any devices that require extended config space, then doing lspci 
-vvvxxx will blow up the machine? Yuck.

Still don't like this approach. It seems like (partially) covering up 
problems rather than solving them.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

