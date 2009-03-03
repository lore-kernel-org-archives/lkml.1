Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZCCKb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZCCKb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 05:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZCCKbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 05:31:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55411 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734AbZCCKbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 05:31:15 -0500
Date: Tue, 3 Mar 2009 10:30:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303103041.0ba4aebd@lxorguk.ukuu.org.uk>
In-Reply-To: <20090303100329.GA5050@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<200903021633.08736.david-b@pacbell.net>
	<20090303004427.GA8638@elte.hu>
	<200903021837.08635.david-b@pacbell.net>
	<1236072446.18955.44.camel@twins>
	<20090303094743.030b2507@lxorguk.ukuu.org.uk>
	<20090303100329.GA5050@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Organization: None.. I'm free I'm free bwhahahahaha!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> _without_ IRQF_ENABLED: where an IRQ handler can take a long 
> time to execute, the handler can be converted to a threaded IRQ 
> handler - where it's fine to enable IRQs as there are no stack 
> nesting issues.

Only if you can mask the interrupt on the APIC without losing it or
having the APIC throw a fit.
 
> So there's no real technical problem here.

In the long term no - but forcing people to make sudden changes to
critical I/O drivers isn't the right way to do it.
