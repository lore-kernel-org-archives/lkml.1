Return-Path: <linux-kernel-owner+w=401wt.eu-S1946022AbXEAVDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946022AbXEAVDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946032AbXEAVDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:03:33 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:41016 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946022AbXEAVDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:03:31 -0400
Message-ID: <4637AA91.1010901@gmail.com>
Date: Tue, 01 May 2007 23:01:05 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com>
In-Reply-To: <4637A3F6.70508@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2007 10:32 PM, Rene Herman wrote:

> On 05/01/2007 04:43 AM, Linus Torvalds wrote:
> 
>> Doubtful. The Tseng ET4000 cards may have been the gold standard in 
>> 1991, but I don't think most people even _remember_ them. And if they 
>> have them in their machines, they probably tend to run a Linux-1.2 
>> kernel, or at least not care a lot about graphics (ie they may have an 
>> old card in the machine just because they need VGA to boot, rather 
>> than because they care about Tseng).
> 
> My 386 has an ET4000. An ET4000AX/W32 even. And you bet it's because 
> it's nifty! Okay, I'll admit the thing doesn't currently run a 2.6 
> kernel...
> 
> The answer will probably be "no", but would this be a good point to ask 
> if this would be a good time to not bother with the mode switching code 
> at all anymore? I'm generally rather appreciative of old gunk but I 
> haven't cared for that specific feature for ages now. I personally don't 
> use framebuffer, but I would if I wanted more than the plain VGA my BIOS 
> sets up.

Confusingly put; please consider a "If the switching code in itself is still 
considered relevant, " to be present here. But rip it all out, I'd say...

> I'd consider keeping anything but VESA 1.2 (which that ET4000 and most 
> all other Super VGA cards of the era also do!) nonsensical and as far as 
> I'm concerned this includes all the VGA modes with the strange number of 
> lines; a 43/60-line VGA screen is too horrible to look at anyway...

Rene.
