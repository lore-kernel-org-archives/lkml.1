Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbYB0PvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbYB0PvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYB0PvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:51:03 -0500
Received: from ns1.suse.de ([195.135.220.2]:60028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYB0PvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:51:01 -0500
Message-ID: <47C586F1.2030803@suse.de>
Date: Wed, 27 Feb 2008 16:51:13 +0100
From: Stefan Seyfried <seife@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071114 SUSE/2.0.0.9-19 Thunderbird/2.0.0.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       Dave Jones <davej@codemonkey.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
 in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
References: <20080225225820.GP2659@elf.ucw.cz> <20080226215641.GE10280@elf.ucw.cz> <20080227131227.GB28528@srcf.ucam.org> <200802271423.12208.rjw@sisk.pl>
In-Reply-To: <200802271423.12208.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 27 of February 2008, Matthew Garrett wrote:
>> On Tue, Feb 26, 2008 at 10:56:41PM +0100, Pavel Machek wrote:
>>
>>> Seems like pm-utils is just a thin wrapper around s2ram, at least in
>>> version debian ships. It does not seem to have its own whitelist.
>> That's a Debian patch.

Yes, the current openSUSE basically uses the same setup, but this will change
in the future.

>>> ...so it is ready to use s2ram, but will fall back to
>>> echo. Unfortunately, that will mean no video resume on _many_
>>> machines.
>> See /usr/lib/pm-utils/sleep.d/99video .
>>
>>> Pretty please, can we get s2ram for Fedora, so that video is restored
>>> there?
>> Stefan told us at FOSDEM that s2ram was being deprecated in OpenSuse, so 
>> I don't think this is the way to go.
> 
> Well, is that really correct?  Stefan??

Not quite :-)

> He probably meant that the s2ram _whitelist_ is going to be deprecated, which
> didn't mean s2ram altogether.

Exactly.

> s2ram is pretty useful anyway, as it combines many mechanisms that allow us to
> bring the video back to life from the user land, so you can use one binary
> instead of a bunch of different programs with different command lines etc.

That's what i like about it and the part i want to keep: do all the
workarounds in one place, ideally with locked VTs and maybe mlock()ed, but get
the workaround options from HAL.

I also had the impression that i had said this quite clearly, but the talk was
short, so the "data compression" of the information might not have been
lossless :-)

Hope this helps to clear up the confusion.
-- 
Stefan Seyfried
R&D Team Mobile Devices            |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg | "Well, surrounding them's out."

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
