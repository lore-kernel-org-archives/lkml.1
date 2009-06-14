Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZFNM5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZFNM5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbZFNM5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:57:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:35183 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753819AbZFNM5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:57:00 -0400
X-Authenticated: #3576790
X-Provags-ID: V01U2FsdGVkX18E6TUz4LEEdWH92cyu2i5E+5mbb5X1UimIs8O+wI
	0FWgOPiMkhm9Ty
Date: Sun, 14 Jun 2009 14:59:10 +0200
From: "Benjamin S." <sbenni@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, js@sig21.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Message-ID: <20090614145910.71c5cd5d@pluto-lenny.milky.way>
In-Reply-To: <alpine.LFD.2.00.0906141440440.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way>
	<200906141400.27331.rjw@sisk.pl>
	<alpine.LFD.2.00.0906141405450.2800@localhost.localdomain>
	<200906141415.16949.rjw@sisk.pl>
	<20090614143708.32ec250c@pluto-lenny.milky.way>
	<alpine.LFD.2.00.0906141440440.2800@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009 14:43:11 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 14 Jun 2009, Benjamin S. wrote:
> >  19:          0         17   IO-APIC-fasteoi   ehci_hcd:usb4, HDA Intel
> >  24:       4830          0  HPET_MSI-edge      hpet2
> 
> This is probably the culprit. Try booting with hpet=disble and check
> whether your resume works.

With this option set resume works.


Benjamin
