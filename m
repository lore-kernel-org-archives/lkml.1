Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbZFNNGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbZFNNGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZFNNGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:06:06 -0400
Received: from www.tglx.de ([62.245.132.106]:53498 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbZFNNGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:06:05 -0400
Date: Sun, 14 Jun 2009 15:05:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Benjamin S." <sbenni@gmx.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, js@sig21.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
In-Reply-To: <20090614145910.71c5cd5d@pluto-lenny.milky.way>
Message-ID: <alpine.LFD.2.00.0906141503160.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141400.27331.rjw@sisk.pl> <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain> <200906141415.16949.rjw@sisk.pl> <20090614143708.32ec250c@pluto-lenny.milky.way>
 <alpine.LFD.2.00.0906141440440.2800@localhost.localdomain> <20090614145910.71c5cd5d@pluto-lenny.milky.way>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Benjamin S. wrote:
> On Sun, 14 Jun 2009 14:43:11 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Sun, 14 Jun 2009, Benjamin S. wrote:
> > >  19:          0         17   IO-APIC-fasteoi   ehci_hcd:usb4, HDA Intel
> > >  24:       4830          0  HPET_MSI-edge      hpet2
> > 
> > This is probably the culprit. Try booting with hpet=disble and check
> > whether your resume works.
> 
> With this option set resume works.

That's what I expected.

Can you boot w/o that option again and provide the full boot log of
the machine ? If you sent one alreay just give me a pointer to the
thread.

Can you please provide the output of /proc/timer_list as well ?

Thanks,

	tglx
