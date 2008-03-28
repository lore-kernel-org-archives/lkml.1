Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYC1B6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYC1B6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYC1B55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:57:57 -0400
Received: from rtr.ca ([76.10.145.34]:3049 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbYC1B54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:57:56 -0400
Message-ID: <47EC50A3.5070304@rtr.ca>
Date: Thu, 27 Mar 2008 21:57:55 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <gregkh@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <20080327160700.GB828@suse.de> <Pine.LNX.4.64.0803280126550.5541@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0803280126550.5541@jikos.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 27 Mar 2008, Greg KH wrote:
> 
>>> It boots, but just a simple suspend/resume (RAM) was enough to kill 
>>> it. It comes back on resume, with an X desktop again, but with no USB 
>>> functionality -- no mouse.
>>> The keyboard still works, so I dropped to a console and tried:
>>>   rmmod usbhid
>>>   insmod usbhid
>>> And the console hung at 100% CPU on the insmod.
>> Haven't heard of this one before sorry.  Jiri, have you?
> 
> No, haven't heard anything similar either. Mark, are you able to collect 
> the stacktraces via alt-sysrq-t at the time the system goes crazy?
..

No where practical to capture them to.
I don't know if the machine was entirely dead,
or just the console at that point.

> Also, as you seem to be able to easily reproduce the bug, git-bisect might 
> reveal the culprit easily. For start, you can try to bisect only let's say 
> usb, hid and acpi code probably ... ?
..

I don't have the XX days necessary for git-bisect right now.
But if there were some likely candidates, I could probably try a couple.
Mostly I just wanted to give a heads-up that all is not well with 2.6.25
for now, and I'll get round to debugging it when I have time to do so.

I haven't yet tried -rc7 on my *other* dissimilar notebook,
but back at -rc2 it also had serious issues with suspend/resume not working.
This is my first look at 2.6.25 (on notebooks) since then.

.. 
>>> kernel: [  111.361099] pciehp_resume ENTRY
>>> kernel: [  112.362047] pciehp: Device 0000:0c:00.0 already exists at c:0, 
>>> cannot hot-add
>>> kernel: [  112.362052] pciehp: Cannot add device 0xc:0
> 
> Hmm, what device is this?
..

Wireless PCIe card on internal slot -- Intel 3945ABG.

