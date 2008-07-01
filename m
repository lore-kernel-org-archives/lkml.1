Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYGAJSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYGAJSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYGAJSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:18:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55288 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYGAJSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:18:37 -0400
Date: Tue, 1 Jul 2008 11:19:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080701091937.GA1871@elf.ucw.cz>
References: <200807010148.02135.rjw@sisk.pl> <20080701063133.GC16642@elte.hu> <4869D4A3.3020000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4869D4A3.3020000@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> The appended patch fixes a regression and is considered as 2.6.26 
>>> material. Everyone having a box with working suspend to RAM is gently 
>>> requested to test it and verify if it doesn't break things.
>>>
>>> The patch applies to the current -git.
>>
>> it's been under testing in tip/out-of-tree for about a week:
>>
>> | commit ee901dc1b9ab94a37ba2efc296fe9ba72bc75adf
>> | Author:     H. Peter Anvin <hpa@zytor.com>
>> | AuthorDate: Tue Jun 24 23:03:48 2008 +0200
>> | Commit:     Ingo Molnar <mingo@elte.hu>
>> | CommitDate: Wed Jun 25 18:48:13 2008 +0200
>> |
>> |     x86 ACPI: normalize segment descriptor register on resume
>>
>> no problems caused by it so far.
>>
>
> Here is the incremental patch which should stick "strictly to the script" 
> of ljmp immediately after writing CR0.PE.  This should be done to the boot 
> code as well; I'm waiting for confirmation from the Elan original reporter 
> before submitting that patch.
>
> I decided to make this an incremental patch to make it bisectable versus 
> the other one, however, it should probably be considered the right thing.
>
> Note: I have not tested this beyond compilation, I'm afraid.

I had to apply it by hand, then I tested it along with Rafael's patch
and it does not seem to break anything here. So feel free to add my
ACK to both.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
