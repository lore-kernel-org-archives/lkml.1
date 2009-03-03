Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZCCLO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZCCLO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZCCLOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:14:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58152 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075AbZCCLOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:14:16 -0500
Date: Tue, 3 Mar 2009 11:13:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303111353.5d9e4a8d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090303104836.GA11532@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<200903021633.08736.david-b@pacbell.net>
	<20090303004427.GA8638@elte.hu>
	<200903021837.08635.david-b@pacbell.net>
	<1236072446.18955.44.camel@twins>
	<20090303094743.030b2507@lxorguk.ukuu.org.uk>
	<20090303100329.GA5050@elte.hu>
	<20090303103041.0ba4aebd@lxorguk.ukuu.org.uk>
	<20090303104836.GA11532@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Organization: None.. I'm free I'm free bwhahahahaha!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, that reads like the boot IRQ erratas of certain chipsets - 
> the APIC could throw a fit essentially locking up the system. 
> FYI, we have fixes for that upstream already.

Good - certainly it used to be the case that masking APIC IRQs and
leaving them masked from the IRQ handled used to do funny things
sometimes.

> i think you severely over-estimate the importance and ratio of 
> drivers that enable irqs within irq handlers. (Nor does anyone 
> want to break them really - we want to have a sane default and 
> we want to flag the broken cases as broken.)

IDE. A lot less people use the IDE stack nowdays but its a big item and
getting it wrong tends to eat your files.


I do object to the attitude shown about "forcing" people. It's a
community project built by a large number of people on a mix of
pragmatic and elegant design balances. Maybe it's just unfortunate choice
of wording but it is the wrong sentiment.
