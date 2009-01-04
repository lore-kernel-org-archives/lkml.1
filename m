Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZADRXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZADRXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZADRXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:23:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33013 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbZADRXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:23:38 -0500
Date: Sun, 4 Jan 2009 18:23:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mpparse.c fix style problems
Message-ID: <20090104172319.GA1238@elte.hu>
References: <1230723533.3738.8.camel@jaswinder.satnam> <20090102172150.GC6759@elte.hu> <3f9a31f40901040917i52df1ef5i7d86ddee05d4d0b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901040917i52df1ef5i7d86ddee05d4d0b1@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> Hello Ingo,
> 
> On Fri, Jan 2, 2009 at 10:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > i think it would be cleaner to rename all the the mpc->mpc_X fields to
> > mpc->X - that alone would give 4 characters per usage site. (we already
> > know that it's an 'mpc' entity - no need to duplicate that in the field
> > too)
> >
> 
> I send [PATCH -tip 0/7] x86 rename all fields mpc_X to X based on this.
> 
> Currently I rename fields of few mpc_X structures from
> arch/x86/include/asm/mpspec_def.h. In this file struct
> intel_mp_floating is still remaining with mpf_X fields, Is this also
> need to be fixed ? if yes then mpf_intel name is OK ?
> 
> Similarly in arch/x86/include/asm/io_apic.h :
> 1. struct mp_config_ioapic with mp_X fields (what name will be best ?)
> 2. struct mp_config_intsrc with mp_X fields
> 
> These are also used in arch/x86/kernel/mpparse.c
> 
> Please let me know should I fix mp_X things first or should I proceed 
> further in mpparse.c as per your suggestions.

i think those should be standardized to mpc_X too, and the fields should 
lose their mp_ prefix.

	Ingo
