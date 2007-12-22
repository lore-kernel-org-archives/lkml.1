Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbXLVUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbXLVUzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXLVUzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:55:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45445 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752900AbXLVUzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:55:40 -0500
Date: Sat, 22 Dec 2007 21:54:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Newall <david@davidnewall.com>
Cc: Richard D <richard@embunus.com>,
       "'Matthew Bloch'" <matthew@bytemark.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071222205432.GA2221@elf.ucw.cz>
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz> <476D35F6.90900@davidnewall.com> <20071222184759.GB31809@elf.ucw.cz> <476D756A.6060507@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476D756A.6060507@davidnewall.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-23 07:06:58, David Newall wrote:
> Pavel Machek wrote:
>> memtest has following problems:
>>
>> 	0) it is kind of hard to run memtest over ssh
>>   
>
> It's kind of hard to run anything over SSH if it has to be run before 
> userspace is up.  But the kernel can collect results from a modified 
> memtest, after it chains back.

memtest can be ran from userspace, that's the point.

>> 	1) if linux fixes some problem with PCI quirk or microcode
>> 	upload, memtest will not see the fix
>>   
>
> What are you saying?  Linux is going to fix faulty RAM?

Yes, that's what CPU microcode update is for. And I want to test my
RAM with up-to-date microcode.

>> 	2) if memory only fails while something else happens (DMA to
>> 	other piece of memory? Hard disk load glitching powre
>> 	supply?), memtest will not see the problem.
>
> These are not RAM faults.  The very last thing you want is evidence that 
> you've got a faulty piece of RAM when the fault is actually a hard disk 
> glitch!

No, it may be power supply leading to RAM problems. Yes, I want to
detect that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
