Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYGEXYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYGEXYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYGEXYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:24:09 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:51073 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYGEXYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:24:08 -0400
Date: Sat, 05 Jul 2008 17:20:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-reply-to: <cccedfc60807051553r69c74bb2wf5080b3c8e9c5036@mail.gmail.com>
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <487001A4.1060406@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no>
 <486FBFAB.5050303@shaw.ca>
 <cccedfc60807051154m7d0a8b44h3294ec29fe07d35a@mail.gmail.com>
 <486FC5D2.80600@shaw.ca>
 <cccedfc60807051553r69c74bb2wf5080b3c8e9c5036@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Nelson wrote:
> On Sat, Jul 5, 2008 at 2:04 PM, Robert Hancock <hancockr@shaw.ca> wrote:
>> Jon Nelson wrote:
>>> Where should APIC errors be posted?
>>> My EPoX MF570-SLI *will not boot* without noapic or nolapic.
>> Post on linux-kernel about that one, with the dmesg from noapic mode and
>> whatever info you can gather from when it won't boot. You might want to also
>> test with 2.6.26-rc8 to see if the problem has already been fixed there.
> 
> Here is the boot log from booting my EPoX MF570SLI in nolapic mode.
> When I boot without nolapic or noapic I get as far as
> 
> io scheduler cfq registered (default)
> 
> I can't boot to serial right now.

You are getting this as the next line after that:

0000:00:02.1 EHCI: BIOS handoff failed (BIOS bug ?) 01010001

You might want to try upgrading your BIOS, it seems like the BIOS is not 
letting go of the USB controller when Linux tries to take over. I don't 
know if that's related to the problem though.

If that doesn't work, I'd try a newer kernel version.

