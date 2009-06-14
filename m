Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZFNMqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZFNMqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZFNMqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:46:37 -0400
Received: from www.tglx.de ([62.245.132.106]:40045 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZFNMqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:46:37 -0400
Date: Sun, 14 Jun 2009 14:46:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Benjamin S." <sbenni@gmx.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, js@sig21.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
In-Reply-To: <20090614143708.32ec250c@pluto-lenny.milky.way>
Message-ID: <alpine.LFD.2.00.0906141444500.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141400.27331.rjw@sisk.pl> <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain> <200906141415.16949.rjw@sisk.pl> <20090614143708.32ec250c@pluto-lenny.milky.way>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Benjamin S. wrote:

This is odd as well:
>            CPU0       CPU1       
>   0:         42          1   IO-APIC-edge      timer
>  24:       4830          0  HPET_MSI-edge      hpet2
> LOC:         42       5070   Local timer interrupts

So we set up only one hpet channel for CPU0 and CPU1 uses the local
timer interrupt. Need to look at that as well.

Venki ???

Thanks,

	tglx
