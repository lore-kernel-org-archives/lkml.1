Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYAYAUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYAYAUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYAYAUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:20:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43254 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751407AbYAYAUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:20:43 -0500
Date: Fri, 25 Jan 2008 01:20:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ian Campbell <ijc@hellion.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
Message-ID: <20080125002054.GA2059@elf.ucw.cz>
References: <1201121530.30671.15.camel@cthulhu.hellion.org.uk> <4797E487.8010108@goop.org> <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org> <479913BA.8000506@zytor.com> <47991809.9060903@goop.org> <47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org> <4799247C.6090008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4799247C.6090008@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-24 15:51:24, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> While we're mucking around in this area, there is another thing which we 
>>> should eventually get around to fixing:
>>>
>>> we need a set of page tables with an identity mapping as well as the 
>>> kernel mapping, for trampolining (during startup, but also during things 
>>> like ACPI suspend/resume.)  Right now, we let those be the swapper page 
>>> tables, but that's probably not really a good idea, since it can hide 
>>> bugs.
>>
>> So you're suggesting a second system pagetable which has a P=V alias as 
>> well as the normal kernel mapping, used only when we actually need that 
>> alias?  Sounds simple enough to arrange.
>>
>
> I just looked at the ACPI suspend code, and it looks like it hacks its own 
> identity map at runtime.  Pavel, am I reading that code right?

Yes, I think so, I believe we do it on both 32 and 64 bit now.

(It is early here. And I almost got the .c wakeup code to work... it
already sets the mode).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
