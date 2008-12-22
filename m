Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYLVWeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYLVWeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbYLVWeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:34:01 -0500
Received: from www.tglx.de ([62.245.132.106]:36139 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbYLVWeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:34:00 -0500
Date: Mon, 22 Dec 2008 23:33:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fabio Comolli <fabio.comolli@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <b637ec0b0812221429m441b9493q97a7ccb82dfc0334@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0812222332400.3723@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>  <20081222150021.GA13839@elte.hu>  <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>  <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>  <b637ec0b0812221239p169967aemf14b2e591779f5cd@mail.gmail.com>
  <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain>  <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com>  <alpine.LFD.2.00.0812222238192.3723@localhost.localdomain>  <b637ec0b0812221412w396337embad90f599a02d3d9@mail.gmail.com> 
 <alpine.LFD.2.00.0812222315460.3723@localhost.localdomain> <b637ec0b0812221429m441b9493q97a7ccb82dfc0334@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio,

On Mon, 22 Dec 2008, Fabio Comolli wrote:

> OK, it seems that you got it.
> 
> The system survived two hibernation / resume cycles without triggering
> the warning and, probably the most important part, the dmesg does not
> have any "jumps" before the "Force enable HPET on resume" line as
> before:
> 
> [  275.647704] PM: Creating hibernation image:
> [  275.648005] PM: Need to copy 177844 pages
> [  275.648005] Intel machine check architecture supported.
> [  275.648005] Intel machine check reporting enabled on CPU#0.
> [  275.648005] Force enabled HPET at resume
> [  275.648005] ACPI: Waking up from system sleep state S4
> [  275.669038] ACPI: EC: non-query interrupt received, switching to
> interrupt mode
> [  275.740697] pcieport-driver 0000:00:01.0: setting latency timer to 64
> [  275.740781] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [  275.740786] pciehp 0000:00:1c.0:pcie02: pciehp_resume ENTRY
> 
> ...and so on.
> 
> As i mentioned in the bug report, to be sure that the bug doesn't
> trigger I have to wait at least on day and > 10 hibernation / resumee
> cycles.

Sure.
 
> But with your first patch the bug triggered at the second cycle, so
> I'm optimist :-)
> 
> I'll keep you informed. Many thanks in advance,

Many thanks to you for following up on this.

     tglx
