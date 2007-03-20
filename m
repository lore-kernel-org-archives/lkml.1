Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXCTGXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXCTGXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 02:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbXCTGXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 02:23:44 -0400
Received: from www.osadl.org ([213.239.205.134]:39816 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752801AbXCTGXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 02:23:43 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Len Brown <lenb@kernel.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070320042734.GA9700@kroah.com>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <200703162132.53906.lenb@kernel.org>
	 <1174127539.3538.207.camel@laptopd505.fenrus.org>
	 <p73k5xg6lwe.fsf@bingen.suse.de>  <20070320042734.GA9700@kroah.com>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 07:30:45 +0100
Message-Id: <1174372246.13341.778.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 21:27 -0700, Greg KH wrote:
> On Sat, Mar 17, 2007 at 02:26:57PM +0100, Andi Kleen wrote:
> > Arjan van de Ven <arjan@infradead.org> writes:
> > > 
> > > well we can do the handshake to take ownership like we do much later in
> > > boot, but that requires PCI to be there and fully discovered, which we
> > > don't have this early.
> > 
> > That's not true - we do early pci discovery. Doing USB handsoff
> > there would be quite possible.
> 
> What, we don't do USB "handoff" early enough in the boot process?  It's
> happening at PCI quirk time now, which I think should be early enough
> for everyone (and too early for some who rely on USB keyboards and
> initramfs shells...)

It happens way after the CPUs are brought up. At this point both the
delay loop calibration and the local APIC calibration are already done.

	tglx


