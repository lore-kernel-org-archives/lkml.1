Return-Path: <linux-kernel-owner+w=401wt.eu-S1763264AbYFETso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763264AbYFETso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762705AbYFETsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:48:32 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64904 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762625AbYFETsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:48:30 -0400
Date: Thu, 5 Jun 2008 20:47:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
In-Reply-To: <20080605185229.GB7030@cvg>
Message-ID: <Pine.LNX.4.55.0806052002010.2875@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805271950010.18833@cliff.in.clinika.pl>
 <20080531101832.GA15170@elte.hu> <20080605091949.GA2307@elte.hu>
 <Pine.LNX.4.55.0806051541210.2875@cliff.in.clinika.pl> <20080605150327.GA22128@elte.hu>
 <Pine.LNX.4.55.0806051911500.2875@cliff.in.clinika.pl> <20080605185229.GB7030@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, Cyrill Gorcunov wrote:

> Since I've got the same hang by using qemu - i think i could test ;)

 I can reproduce the hang, except with a slightly different options.  I
have spotted the places where the watchdog is set up incorrectly.  I shall
post fixes shortly, once I have got them polished and tested.  Feel free
to throw them at your qemu.

 Also it's worth noting there's more breakage of the NMI watchdog for this
configuration ("maxcpus=1 noapic") -- it fails to tick on the CPU #0 on my
system for some reason, but that's well beyond the scope of this series,
so I am not going to look into it.

  Maciej
