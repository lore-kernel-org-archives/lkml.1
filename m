Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYGCL4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYGCL4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYGCLzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:55:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:36305 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbYGCLzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:55:13 -0400
Subject: Re: Multiple MSI
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arnd Bergmann <arnd@arndb.de>, michaele@au1.ibm.com,
       linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080703113128.GC14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org>
	 <1215060119.21182.77.camel@pasglop> <1215067484.17950.35.camel@localhost>
	 <200807031110.30072.arnd@arndb.de> <1215076620.19689.2.camel@pasglop>
	 <20080703113128.GC14894@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 21:41:06 +1000
Message-Id: <1215085266.19689.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 05:31 -0600, Matthew Wilcox wrote:
> On Thu, Jul 03, 2008 at 07:17:00PM +1000, Benjamin Herrenschmidt wrote:
> > > Some years ago, we had discussions about getting rid of IRQ numbers
> > > altogether, or at least the requirement to have device drivers know
> > > about them. Does anyone remember what happened to that idea?
> > 
> > I think it's not totally dead. Last I heard, someone (jgarzik ?) was
> > slowly, bit by bit, removing the dependencies on the irq argument on irq
> > handlers which is one step in the direction.
> 
> I think that project's dead, Jim.  http://lkml.org/lkml/2008/4/22/578

Ouch, missed that one... sad, would have been a good idea in the long
run. irq_desc array is a big PITA.

> You can't do that.  /proc/interrupts is so terribly useful for a
> sysadmin that you can't remove information from it.

You can create a new one with informations about the new stuff..

Anyway, looks like it's not happening and we'll be stuck with the bloody
array for the time being. Crap.

Ben.


