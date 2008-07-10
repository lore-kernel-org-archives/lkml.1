Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbYGJUSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbYGJUSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYGJUSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:18:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39695 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbYGJUSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:18:22 -0400
Date: Thu, 10 Jul 2008 22:18:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
       andi@firstfloor.org, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080710201801.GA6168@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com> <m1prplv71d.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prplv71d.fsf@frodo.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> A lot of your code is generic, and some of it is for just x86_64.  
> Since the cpus are capable of running in 32bit mode.  We really need 
> to implement x86_32 and x86_64 support in the same code base.  Which I 
> believe means factoring out pieces of io_apic_N.c into things such as 
> msi.c that can be shared between the two architectures.

i think the APIC code should be fully unified down the line - the 
APIC/IOAPIC knows little about the mode the CPU is running in and has to 
be programmed the same way independent of which mode the CPU is in. The 
current fork between the 32-bit and 64-bit APIC code is in good part 
artificial.

	Ingo
