Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYC3UUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYC3UUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYC3UUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:20:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46660 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYC3UUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:20:06 -0400
Date: Sun, 30 Mar 2008 22:20:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: bugme-daemon@bugzilla.kernel.org, rjw@sisk.pl, bunk@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [Bug 10345] USB HID problems after resume
Message-ID: <20080330202047.GE11839@elf.ucw.cz>
References: <20080328223544.A61F711D10C@picon.linux-foundation.org> <47EE78C9.5090006@rtr.ca> <47EE793C.5070105@rtr.ca> <20080330114834.GA6510@elf.ucw.cz> <47EFD1F1.8010501@rtr.ca> <20080330182243.GA11839@elf.ucw.cz> <47EFF4F6.1050302@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EFF4F6.1050302@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-03-30 16:15:50, Mark Lord wrote:
> Pavel Machek wrote:
>> On Sun 2008-03-30 13:46:25, Mark Lord wrote:
>>> Pavel Machek wrote:
>>>> On Sat 2008-03-29 13:15:40, Mark Lord wrote:
>>>> ..
>>>>> Just happened again.  The machine resumed from RAM with no functioning USB.
>>>>> Still running the exact same 2.6.25-rc7 kernel as before, with the RTC conflict fixed.
>>>>>
>>>>> WTF?
>>>>> 3GB of RAM? Try iommu=soft.
>>> ..
>>>
>>> What does that option do (it is not in Documentation/kernel-parameters.txt),
>>> and why do you suspect it may make a difference here?
>>
>> See x86_64/boot-options.txt . Yes, that should be fixed.
>>
>> I had strange problems, and it looks like iommu does not have proper
>> suspend/resume support. > 3GB machines hit that. Do you have one?
> ..
>
> This is a 32-bit system / kernel, so I'm guessing that this option is not applicable.
>
> Right?  (it does have 3GB of RAM, though).

Not 100% sure... I've seen strangeness on 32-bit systems, too. Can you
simply pass mem=2G and see what happens?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
