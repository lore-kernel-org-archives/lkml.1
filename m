Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbZAHPFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbZAHPFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZAHPE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:04:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53045 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751132AbZAHPE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:04:57 -0500
Date: Thu, 8 Jan 2009 15:04:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Adam Osuchowski <adwol@zonk.pl>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: Is 386 processor still supported?
Message-ID: <20090108150448.2393aeb0@lxorguk.ukuu.org.uk>
In-Reply-To: <1231424833.11687.452.camel@twins>
References: <20090108120338.6b8b4567@zonk.pl>
	<alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz>
	<1231424025.11687.447.camel@twins>
	<alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz>
	<1231424833.11687.452.camel@twins>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hmm. Where in Kconfig is SMP for M386 not allowed?
> 
> Dunno, kconfig is too much of a jungle for a simple person like me ;-)
> 
> But afaik i386 (and possibly i486) don't support nearly enough for a
> modern SMP system.
> 
> Alan used to have i486-smp I think, one of the very few ever made.

The first systems that supported the Intel MP standard are 486 based with
external APIC. The prior systems used various proprietary MP interfaces
from the simple stuff in the Compaq (which Linux doesn't support as
Compaq refused to allow Thomas Radke to contribute it) to the fairly
extreme end of things with the Sequent boxes.

In addition our FPU emulation and some of our handling for x86 processors
where we have to do the WP bit in software is also not SMP safe.

So our minimal spec for SMP is probably 486DX + external Intel APIC.

In practice I doubt there is a single Intel APIC type 486 SMP box on the
planet running Linux (or quite possibly running at all)

Alan
