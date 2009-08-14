Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZHNA32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZHNA32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 20:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZHNA31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 20:29:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56601 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZHNA31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 20:29:27 -0400
Subject: Re: [patch 00/14] clocksource / timekeeping rework V3
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090813154034.613706651@de.ibm.com>>
References: <20090813154034.613706651@de.ibm.com>>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 17:28:21 -0700
Message-Id: <1250209701.7149.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 17:40 +0200, Martin Schwidefsky wrote:
> Greetings,
> version 3 of the clocksource / timekeeping cleanup patches. As far as
> I'm concerned this is the final version, modulo bugs and review results.
> All the things I want to have in there are done.
> 
> The latest additions are:
> 1) Change read_persistent_clock to return a struct timespec instead of
>    an unsigned long with the number of seconds.
> 2) Introduce read_boot_clock to initialize wall_to_monotonic.
> 
> The patch set is based on todays upstream tree plus the patches from
> the tip tree, if anyone wants to try them you need to pull from the
> master branch of
>     git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip

So I got the patch queue up and running and it's functioning correctly
on the box I tested it with (although its not a super interesting box:
TSC is unstable and it only has ACPI PM).

Although I've not been able to test changing clocksources, I assume you
gave that a whirl? I'll test that as soon as I can get access to a TSC
friendly box.

Once the "cycles_last = 0" fix is in to make sure TSC boxes work, I
think this set should be ok to go in.

thanks
-john

