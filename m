Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXLZHYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXLZHYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 02:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXLZHYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 02:24:34 -0500
Received: from il.qumranet.com ([82.166.9.18]:54513 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXLZHYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 02:24:33 -0500
Message-ID: <4772016D.30900@qumranet.com>
Date: Wed, 26 Dec 2007 09:23:25 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Robert Hancock <hancockr@shaw.ca>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no> <200712251312.43478.carlos@strangeworlds.co.uk> <47713B2B.3000105@shaw.ca> <200712251926.51628.rjw@sisk.pl> <alpine.LFD.0.9999.0712252023290.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712252023290.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Wed, 26 Dec 2007 09:23:25 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>
>> IMO, we should check which version of the specification we're supposed to
>> follow, on the basis of FADT contents, for example, and follow this one.
>>     
>
> No, we should try to figure out what Windows does. *If* windows checks the 
> version, we should do that too. But we should absolutely *not* just assume 
> that the documentation is an accurate picture of reality.
>
> Does anybody know how we could find out? 
>
>   

Run it in a virtual machine, with the ACPI methods of interest wired to
output to some port, and log that I/O port in the monitor/emulator.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

