Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYIBKX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYIBKX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYIBKXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 06:23:20 -0400
Received: from NAT-170.Local.iNES.RO ([80.86.100.170]:46430 "EHLO
	blade.ines.ro" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751033AbYIBKXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 06:23:19 -0400
Subject: Re: IRQ routing / assignment issue
From: Radu Rendec <radu.rendec@ines.ro>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48BC248E.702@shaw.ca>
References: <fa.Ayf504otegg3VVbRsozI1UFd/6Y@ifi.uio.no>
	 <48BC248E.702@shaw.ca>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 13:23:13 +0300
Message-Id: <1220350993.16764.27.camel@blade.ines.ro>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 11:21 -0600, Robert Hancock wrote:
> The kernel doesn't really have any way to change the physical 
> device/slot to IRQ mapping. In some cases there are BIOS settings which 
> might influence this, but in most cases it's impossible to change (i.e. 
> devices physically wired to the same IRQ line).

Thanks for your quick reply. I know there are 4 physical interrupt
lines, interleaved for the many devices connected to a bus, so that, if
most of the devices issue INTA, the interrupts are actually asserted on
different pins of the apic (an almost uniform distribution of the
interrupts, but still, two devices can share the same physical line). I
also know that it's possible to change the (logical) irq levels assigned
to physical INTA-INTD (perhaps using the pirq= parameter).

As I have limited knowledge of hardware implementations, I'm asking you
if it's usual/possible for a dual-processor system to have the same
physical irq pin connected to the same irq line of _different_ pci
buses. To put it in other words, is it possible for two devices on
_separate_ pci buses to physically share the same irq pin?

Thanks,

Radu Rendec


