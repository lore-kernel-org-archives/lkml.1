Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbZCSKCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbZCSKCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZCSKC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:02:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbZCSKC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:02:27 -0400
Date: Thu, 19 Mar 2009 11:01:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christopher Schramm <debian@shakaweb.org>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: APIC problem report
Message-ID: <20090319100122.GA30358@elte.hu>
References: <49C1FE7D.9070605@shakaweb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C1FE7D.9070605@shakaweb.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christopher Schramm <debian@shakaweb.org> wrote:

> Hi,
>
> I found a problem with APIC on a desktop PC equipped with Asus' 
> M2N, running the manufacturer's AMI BIOS - version 0803.
>
> I've tried booting Knoppix 5.3.1 (Kernel 2.6.24.4) and GParted 
> live (Debian's 2.6.26-13). Both will only boot if noapic parameter 
> is used. Otherwise I get "MP-BIOS bug: 8254 timer not connected to 
> IO-APIC" resulting in a kernel panic.
>
> apic=debug gives "ACPI: Core revision 20080321", "Version 
> 80050010" (twice), "ID: 0", "LVT0: 700", "LVT1:400" and "ESR value 
> before enabling vector: 0x00000004 after: 0x00000000".
>
> Hope it's of some use (and the best place to report it)

Any chance to build and run a more recent kernel on it, to see 
whether this issue still occurs? The latest APIC code is at:

  http://people.redhat.com/mingo/tip.git/README

And i suspect you should pick up the Knoppix .config and build with 
that to reproduce this issue. A digital picture of the panic would 
be useful as well.

	Ingo
