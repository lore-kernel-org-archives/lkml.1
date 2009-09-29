Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZI2RNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZI2RNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZI2RNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:13:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42328 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZI2RNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:13:23 -0400
Date: Tue, 29 Sep 2009 19:13:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Shane Wang <shane.wang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20090929171318.GC14405@elf.ucw.cz>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com> <200909262344.21257.rjw@sisk.pl> <20090928210252.GD1960@elf.ucw.cz> <200909282307.56190.rjw@sisk.pl> <4AC1267D.6020405@zytor.com> <20090928211745.GA2119@elf.ucw.cz> <4AC1AA61.8070408@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC1AA61.8070408@intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-29 14:34:09, Shane Wang wrote:
> Pavel Machek wrote:
>> On Mon 2009-09-28 14:11:25, H. Peter Anvin wrote:
>>> On 09/28/2009 02:07 PM, Rafael J. Wysocki wrote:
>>>>> Well, I worry that S3 support for TXT makes TXT completely useless. A
>>>>> little liquid nitrogen, remove RAM, place it in another machine,
>>>>> modify it in any way you want, more liquid nitrogen, place it back.
>>>>>
>>>>> Oops, protection provided by TXT is lost.
>>>> Ah, I see your point now.
>>>>
>>> Shane Wang sent me a patch for S3 support, but it missed the merge window:
>>>
>>> 	http://marc.info/?i=4A9CE0B2.5060608@intel.com
>>>
>>> *As far as I understand* -- and I haven't looked into it in detail yet,
>>> having just come back from Plumber's -- this provides integrity
>>> protection, not content extraction protection.

Well, documentation seems to suggest it provides content protection,
too. If not, should that be clearly documented in Doc*/intel_txt?
[Also, I'd expect threat model aka "what does it protect against there"].

>> How does it provide integrity protection? I'm free to modify RAM
>> content in the other machine....

>
> Before S3 sleep, tboot patch will MAC the memory, and after S3 resume, 
> the memory integrity will be verified according to the MAC value. So, you 
> can't modify RAM, or else you will fail on S3 resume.
>
> The current patch hpa mentioned is for userspace memory integrity. For 
> kernel memory integrity, the code is already in with the previous txt 
> patch.

Ok, and what prevents me from commenting out the MAC checking code?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
