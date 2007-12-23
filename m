Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXLWLTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXLWLTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 06:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXLWLTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 06:19:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51400 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751355AbXLWLTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 06:19:08 -0500
Date: Sun, 23 Dec 2007 12:17:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Newall <david@davidnewall.com>
Cc: Richard D <richard@embunus.com>,
       "'Matthew Bloch'" <matthew@bytemark.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071223111752.GA2340@elf.ucw.cz>
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz> <476D35F6.90900@davidnewall.com> <20071222184759.GB31809@elf.ucw.cz> <476D756A.6060507@davidnewall.com> <20071222205432.GA2221@elf.ucw.cz> <476E0FDF.9030407@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476E0FDF.9030407@davidnewall.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-23 18:05:59, David Newall wrote:
> Pavel Machek wrote:
>> On Sun 2007-12-23 07:06:58, David Newall wrote:
>>   
>>> It's kind of hard to run anything over SSH if it has to be run before 
>>> userspace is up.  But the kernel can collect results from a modified 
>>> memtest, after it chains back.
>>>     
>>
>> memtest can be ran from userspace, that's the point.
>>   
>
> I'm not sure I believe that.  You need to tinker with hardware tables 
> before you know what physical RAM is being used.  Sequential virtual

No, I can just use /dev/mem. (After passing mem=XXX exactmap to kernel
so that I know what I may play with).

>> Yes, that's what CPU microcode update is for. And I want to test my
>> RAM with up-to-date microcode.
>>   
>
> Don't microcode updates fix CPU bugs?  That's not fixing faulty RAM.

L1/L2 cache is part of memory subsystem.

> I suppose a CPU retains microcode updates, once loaded, until power-down or 
> some hard reboot that you surely can avoid.  If it does happen that
> you

If CPU retains microcode after reset, then you are right. I'm not
sure.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
