Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYC3SWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYC3SWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 14:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYC3SWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 14:22:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41737 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYC3SWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 14:22:06 -0400
Date: Sun, 30 Mar 2008 20:22:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: bugme-daemon@bugzilla.kernel.org, rjw@sisk.pl, bunk@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [Bug 10345] USB HID problems after resume
Message-ID: <20080330182243.GA11839@elf.ucw.cz>
References: <20080328223544.A61F711D10C@picon.linux-foundation.org> <47EE78C9.5090006@rtr.ca> <47EE793C.5070105@rtr.ca> <20080330114834.GA6510@elf.ucw.cz> <47EFD1F1.8010501@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EFD1F1.8010501@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-03-30 13:46:25, Mark Lord wrote:
> Pavel Machek wrote:
>> On Sat 2008-03-29 13:15:40, Mark Lord wrote:
>> ..
>>> Just happened again.  The machine resumed from RAM with no functioning USB.
>>> Still running the exact same 2.6.25-rc7 kernel as before, with the RTC conflict fixed.
>>>
>>> WTF?
>>
>>> 3GB of RAM? Try iommu=soft.
> ..
>
> What does that option do (it is not in Documentation/kernel-parameters.txt),
> and why do you suspect it may make a difference here?

See x86_64/boot-options.txt . Yes, that should be fixed.

I had strange problems, and it looks like iommu does not have proper
suspend/resume support. > 3GB machines hit that. Do you have one?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
