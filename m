Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZAYWA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZAYWA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZAYWAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:00:50 -0500
Received: from ds.netgate.net ([205.214.170.232]:52087 "EHLO ds.netgate.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZAYWAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:00:50 -0500
Message-ID: <497CE10F.3030502@macslab.com>
Date: Sun, 25 Jan 2009 14:00:47 -0800
From: Charles Landau <clandau@macslab.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Gateway DX4720-03 apic problem
References: <497CBF12.10202@macslab.com> <497CC962.7060900@shaw.ca>
In-Reply-To: <497CC962.7060900@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Charles Landau wrote:
>> I have a new Gateway DX4720-03 PC and have discovered that it won't 
>> install Fedora 10 unless I give the kernel boot option "noapic" or 
>> "nolapic".
>>
>> This system's processor is the Intel Pentium Dual Core E5200.
>>
>> It would seem that this is either a kernel bug to be fixed, or a 
>> documentation bug so users of this machine know about the workaround. 
>> I'll report the bug if someone will tell me how.
> 
> I think you just did report it :-)
> 
> Well, it's something that should be fixed in the kernel, either it's a 
> kernel bug or hardware busted in some way that we should be detecting.
> 
> How is it failing to install, is it locking up at some point, etc?

When I boot off the Fedora 10 full distribution DVD, which I believe is 
kernel 2.6.27.5, at the first screen, "Welcome to Fedora 10!", I tell it 
to Install or upgrade, and then I get a variety of errors on the text 
console, including:

    ata1.00 failed to IDENTIFY

and

    PNP: PS/2 appears to have AUX port disabled ...

and problems enumerating USB devices, and

    ehci_hcd 0000:00:04.1: Unlink after no_IRQ? Controller is probably 
using the wrong IRQ.

and

    ohci_hcd 0000:00:04.0: Unlink after no_IRQ? Controller is probably 
using the wrong IRQ.

after which it does nothing. There is no power to USB and PS/2 devices.

Let me know any other ways I can help you diagnose this.
