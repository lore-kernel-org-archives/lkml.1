Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYC3UQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYC3UQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYC3UPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:15:55 -0400
Received: from rtr.ca ([76.10.145.34]:3500 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbYC3UPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:15:55 -0400
Message-ID: <47EFF4F6.1050302@rtr.ca>
Date: Sun, 30 Mar 2008 16:15:50 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: bugme-daemon@bugzilla.kernel.org, rjw@sisk.pl, bunk@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [Bug 10345] USB HID problems after resume
References: <20080328223544.A61F711D10C@picon.linux-foundation.org> <47EE78C9.5090006@rtr.ca> <47EE793C.5070105@rtr.ca> <20080330114834.GA6510@elf.ucw.cz> <47EFD1F1.8010501@rtr.ca> <20080330182243.GA11839@elf.ucw.cz>
In-Reply-To: <20080330182243.GA11839@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2008-03-30 13:46:25, Mark Lord wrote:
>> Pavel Machek wrote:
>>> On Sat 2008-03-29 13:15:40, Mark Lord wrote:
>>> ..
>>>> Just happened again.  The machine resumed from RAM with no functioning USB.
>>>> Still running the exact same 2.6.25-rc7 kernel as before, with the RTC conflict fixed.
>>>>
>>>> WTF?
>>>> 3GB of RAM? Try iommu=soft.
>> ..
>>
>> What does that option do (it is not in Documentation/kernel-parameters.txt),
>> and why do you suspect it may make a difference here?
> 
> See x86_64/boot-options.txt . Yes, that should be fixed.
> 
> I had strange problems, and it looks like iommu does not have proper
> suspend/resume support. > 3GB machines hit that. Do you have one?
..

This is a 32-bit system / kernel, so I'm guessing that this option is not applicable.

Right?  (it does have 3GB of RAM, though).

Cheers
