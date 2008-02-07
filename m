Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbYBGWtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbYBGWtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbYBGWsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:48:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55724 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758253AbYBGWsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:48:52 -0500
Date: Thu, 7 Feb 2008 23:49:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080207224908.GD6096@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802072312.31430.rjw@sisk.pl> <20080207222845.GA6096@elf.ucw.cz> <200802072340.06138.rjw@sisk.pl> <47AB8A0F.9@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB8A0F.9@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-02-07 14:45:35, H. Peter Anvin wrote:
> Rafael J. Wysocki wrote:
>
>>  ENTRY(wakeup_long64)
>>  wakeup_long64:
>> -	movq    saved_magic, %rax
>> -	movq    $0x123456789abcdef0, %rdx
>> -	cmpq    %rdx, %rax
>> -	jne     bogus_64_magic
>> +	movq	saved_magic, %rax
>> +	movq	$0x123456789abcdef0, %rdx
>> +	cmpq	%rdx, %rax
>> +	jne	bogus_64_magic
>
> A random magic is probably more likely to be unique than something like 
> that.

This is already "unlikely enough", I'd say. It does not look like a
pointer, and it is long enough.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
