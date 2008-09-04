Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbYIDTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbYIDTU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYIDTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:20:20 -0400
Received: from www.tglx.de ([62.245.132.106]:59714 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbYIDTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:20:19 -0400
Date: Thu, 4 Sep 2008 21:20:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Parnell <mparnell@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc0 Power Bugs with HP/Compaq Laptops
In-Reply-To: <680ad8bc0808070757u49e13b3br1f69fb4881dc44ce@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809042116580.3243@apollo.tec.linutronix.de>
References: <680ad8bc0808070757u49e13b3br1f69fb4881dc44ce@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Thu, 7 Aug 2008, Matt Parnell wrote:
> I have had a long ongoing ordeal dealing with the problems associated
> with the HP Pavilion Laptops, mine being a dv9000 series. It seems
> that these either have a broken HPET table, a missing HPET table, or
> some other ACPI issue, as this thing has always had many issues
> regarding ACPI. First, C1E was broken until I totally disabled it with
> a patch, but since .27, that code has been rewritten, and now for some
> reason HPET isn't working anymore, as I have to set the
> clocksource=tsc. On top of that, the tsc clocksource is unstable, and
> with or without dynticks the .27 kernels on my laptop feel slower, and
> laggy, as even KDE slows down whilest using it. Everything works fine
> if I disable the local apic (lapic), but when I do, only one of my CPU
> cores is detected and used, and the CPU frequency scaling doesn't work
> either. No matter what I do with .27, it just won't work.

There is a series of related fixes to C1E/HPET in the bugzilla entry
http://bugzilla.kernel.org/attachment.cgi?id=17622

Patch is available from:  http://bugzilla.kernel.org/show_bug.cgi?id=11418 

Can you please test that on the latest linus git ?

Thanks,

       tglx
