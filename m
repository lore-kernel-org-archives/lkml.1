Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbXKYVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbXKYVnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 16:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXKYVnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 16:43:01 -0500
Received: from www.tglx.de ([62.245.132.106]:37578 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbXKYVnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 16:43:00 -0500
Date: Sun, 25 Nov 2007 22:42:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] Re: nohz and strange sleep latencies
In-Reply-To: <20071125202557.GB7739@elf.ucw.cz>
Message-ID: <alpine.LFD.0.9999.0711252239070.26417@localhost.localdomain>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain>
 <20071120225246.GA24380@elte.hu> <20071122185238.GA1821@elf.ucw.cz> <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain> <20071125202557.GB7739@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007, Pavel Machek wrote:
> Hi!
> 
> Okay, so the problem seems to be we are using unreliable lapic
> timer... which is stopped in C3 (and in C2 on broken machines).
> 
> I do not see any mechanism to disable lapic; there seems to be some
> mechanism to work around stopped lapic timer is used (in
> acpi/processor_idle.c) but it does not seem to work. So what about
> this?

nolapic_timer on 32bit
noapictimer on 64bit 

Sigh, I know that sucks, but it's the history of the diverged trees.

      tglx
