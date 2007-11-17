Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbXKPWH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbXKPWH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762796AbXKPWHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:07:34 -0500
Received: from dns2.fullrate.dk ([89.150.129.10]:63311 "EHLO dns2.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761650AbXKPWHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:07:33 -0500
Message-ID: <473E9290.3040006@minimum.se>
Date: Fri, 16 Nov 2007 23:04:48 -0800
From: Martin Olsson <mnemo@minimum.se>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org,
       Ubuntu Devel Discuss <ubuntu-devel-discuss@lists.ubuntu.com>
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
References: <473E815F.30900@minimum.se> <20071116213137.6efe3f9e@the-village.bc.nu>
In-Reply-To: <20071116213137.6efe3f9e@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about that, I checked the "has security impact" checkbox and that 
marked it as private by default. This is a very well known problem 
though so keeping secret certainly does not make sense. I have manually 
removed the "private" flag now.

The content of the bug report was as follows:
---------------------------------------------

Repro steps:

1. Install gutsy gibbon (or probably any ubuntu)
2. Start a gnome terminal
3. Run this command:

    :(){ :|:& };:

4. Ubuntu starts to work furiously, after less than a second terminal 
gets flooded with "low resources" message, and within a few seconds the 
whole machine breaks down complete to the point where no a single pixel 
is updated and the mouse cannot be moved at all. It's not possible to 
escape to a ALT-Fn console terminal and CTRL-ALT-DEL does not work.

Okay, so this is not as bad as winnuke.exe because it's not remote but I 
just did it on my shared hosting co and their server went down. And I 
mean seriously, there should be a way for a user to abort stuff that 
hogs resources this type of complete breakdown is NEVER acceptible. I 
had to power of the machine and my file system got royally screwed (long 
fsck etc).

Some of you might say this is like the oldest trick in the book, yada 
yada yada...


		Martin



Alan Cox wrote:
> On Fri, 16 Nov 2007 21:51:27 -0800
> Martin Olsson <mnemo@minimum.se> wrote:
> 
>> Dear kernel hackers,
>>
>> This is a message from below 0x7FFFFFFF. Please look at this bug (it's 
>> not a new concept but still):
>> https://bugs.launchpad.net/ubuntu/+bug/163185
> 
> It seems to want people to register to view it. I guess Ubuntu should fix
> launchpad then we can see the bug report
> 
> Alan
> -

