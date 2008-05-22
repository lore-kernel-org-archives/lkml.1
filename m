Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYEVP1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYEVP1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYEVP1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:27:04 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61673 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752653AbYEVP1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:27:02 -0400
Date: Thu, 22 May 2008 16:25:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Kevin Hao <kexin.hao@windriver.com>
cc: Clemens Ladisch <clemens@ladisch.de>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
Subject: Re: [PATCH] x86: Get irq for hpet timer
In-Reply-To: <1211441231.7323.10.camel@kevin-desktop>
Message-ID: <Pine.LNX.4.55.0805221609280.13339@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>  <482D49CF.4030902@ladisch.de>
 <1210929270.11912.3.camel@kevin-desktop>  <4831A678.5070208@ladisch.de>
 <1211274219.8718.7.camel@kevin-desktop>  <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
  <4833DD38.2010702@ladisch.de>  <Pine.LNX.4.55.0805220105560.4894@cliff.in.clinika.pl>
 <1211441231.7323.10.camel@kevin-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Kevin Hao wrote:

> But if we avoid all the legacy range, the hpet timer will have no chance
> to work on a host using legacy PIC.

 It's not meant to be wired to the legacy PIC anyway (except from the
timers #0 and #1 in some configurations, meant to emulate timer interrupts
of the 8254 and the RTC), though I can imagine such a non-standard
extension.

> Yes, we should setup routing in the I/O APIC and use level-triggered
> mode. I think it's better to use acpi_register_gsi than mp_register_gsi.
> Is that right?

 It sounds right to me.

  Maciej
