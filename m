Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbXLZFN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbXLZFN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 00:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXLZFNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 00:13:22 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:55532 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbXLZFNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 00:13:21 -0500
Date: Tue, 25 Dec 2007 23:13:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
 suspend-to-RAM
In-reply-to: <alpine.LFD.0.9999.0712252023290.21557@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <4771E2EC.7020407@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no>
 <200712251312.43478.carlos@strangeworlds.co.uk> <47713B2B.3000105@shaw.ca>
 <200712251926.51628.rjw@sisk.pl>
 <alpine.LFD.0.9999.0712252023290.21557@woody.linux-foundation.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>> IMO, we should check which version of the specification we're supposed to
>> follow, on the basis of FADT contents, for example, and follow this one.
> 
> No, we should try to figure out what Windows does. *If* windows checks the 
> version, we should do that too. But we should absolutely *not* just assume 
> that the documentation is an accurate picture of reality.
> 
> Does anybody know how we could find out? 
> 
> 			Linus
> 

Well, it seems that if one had a checked (debug) build of Windows (or at 
least the acpi.sys driver) installed, as well as a copy of the Microsoft 
ASL compiler, they could compile and temporarily override the DSDT with 
a hacked one that would output what the device power states were in some 
fashion (maybe through the kernel debugger). Some info about this here:

http://download.microsoft.com/download/1/8/f/18f8cee2-0b64-41f2-893d-a6f2295b40c8/TW04015_WINHEC2004.ppt

I suspect that might require more Windows hacking skill and/or 
motivation than one might be likely to find on this list, though :-)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

