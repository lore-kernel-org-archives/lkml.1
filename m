Return-Path: <linux-kernel-owner+w=401wt.eu-S1764372AbXEYRzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764372AbXEYRzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762951AbXEYRzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:55:45 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:63540 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354AbXEYRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kzmAnnMps4SaOA/xauLTAfQsQ6Pdpi0TslbMOa0AenWwAu75T7tAu6mWIduiGUrw0hgjvvMGXFMQKdczvkW2Rg3gsNP5Yx+uSbZIqnS0r0bV6Gj4K1Q94Zi6fkIa61t5AMur7EQTo1Cm8bjhSu0Wb2C39kmQcJadfNP8S5+/fM0=
Message-ID: <8bd0f97a0705251055n12dab89apbb246a0c82b56ef6@mail.gmail.com>
Date: Fri, 25 May 2007 13:55:31 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Daniel Newby" <daniel.a.newby@gmail.com>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <ba1ee50c0705250309j64eb1d99j45b1ed35a4a5b1ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
	 <200705240929.51696.rgetz@blackfin.uclinux.org>
	 <20070524152318.GA4491@linux-sh.org>
	 <200705241332.30335.rgetz@blackfin.uclinux.org>
	 <20070525040445.GA8395@linux-sh.org>
	 <ba1ee50c0705250309j64eb1d99j45b1ed35a4a5b1ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Daniel Newby <daniel.a.newby@gmail.com> wrote:
> On 5/24/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > So far the only example anyone has provided outside of periodic timers or
> > hardware reset has been dumping the stack when something gets stuck.
> > Softlockup does this already today, using a timer.
>
> Many watchdogs can be hooked up to a non-maskable interrupt (NMI) that
> cannot be disabled or preempted.  You get a stack dump even for drastic
> bugs:  ISR lock up, timer misconfiguration, level-sensitive interrupt
> line stuck asserted, and so forth.  Getting that information by other
> means can be painful and/or expensive.
>
> The Blackfin chip in the original message appears to support watchdog
> NMI.

it does ... it has four modes:
 - reset (drivers/char/watchdog/bfin_wdt.c)
 - interrupt (i'll prob write a clockevents driver for this)
 - NMI (no plans to do anything for this as NMI is unused in Blackfin)
 - nothing (have yet to find a use case for this)
-mike
