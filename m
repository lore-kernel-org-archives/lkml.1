Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbXKURGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbXKURGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXKURGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:06:32 -0500
Received: from smtp05.mtu.ru ([62.5.255.52]:59283 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbXKURGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:06:31 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Wed, 21 Nov 2007 20:06:21 +0300
References: <200711052201.17150.arvidjaar@mail.ru> <200711112010.24874.rjw@sisk.pl> <200711170001.46710.arvidjaar@mail.ru> <200711162233.52910.rjw@sisk.pl> <20071121124503.GB5474@ucw.cz>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20071121170624.72FEE9EBE8E@smtp05.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

> Hi!
> 
>> > > > It works. Subjectively I have relatively long pause after first
>> > > > Suspending console message (where it hangs otherwise), according to
>> > > > dmesg timestamp it is about 1 second before next messages appear.
>> > > > Also last two times I tried it writeout of suspend image was really
>> > > > slow; it was both with and without battery. Reading on resume in
>> > > > really in order of magnitude faster.
>> > > > 
>> > > > But manual STD so far works both on AC (with or without battery) or
>> > > > on battery.
>> > > > 
>> > > > Of course it is possible that battery gets exhausted during STD,
>> > > > but system is not switched off. Rather I would suspect something
>> > > > like ACPI notification that comes during freeze ...
>> > > 
>> > > Frankly, I'm suspecting a deadlock in the ACPI code.
>> > > 
>> > > Please try to make kpowersave start hibernation a bit earlier and see
>> > > what happens.
>> > > 
>> > > What's your critical time now?
>> > > 
>> > > 
>> > 
>> > it was set to 5%. Setting it to 10% makes it work, but it just confirms
>> > what I said before - suspend-to-RAM in normal battery conditions (or
>> > without battery) works.
>> 
>> Yes.
> 
> I have something similar in suse bugzilla, but there the claim is 'it
> always works if I trigger it manually'.

ehh ... did not I say exactly the same thing?

P.S. may I ask you to reply to all - at least to the person who initiated
this thread ...


