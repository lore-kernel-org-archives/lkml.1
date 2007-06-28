Return-Path: <linux-kernel-owner+w=401wt.eu-S1765752AbXF1VrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765752AbXF1VrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 17:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760915AbXF1VrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 17:47:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52427 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760558AbXF1VrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 17:47:16 -0400
From: John Keller <jpk@sgi.com>
Message-Id: <200706282147.l5SLlDAK270776@fcbayern.americas.sgi.com>
Subject: Re: 2.6.22-rc6-mm1: io_apic build error
To: akpm@linux-foundation.org (Andrew Morton)
Date: Thu, 28 Jun 2007 16:47:12 -0500 (CDT)
Cc: randy.dunlap@oracle.com (Randy Dunlap), linux-kernel@vger.kernel.org,
       jpk@sgi.com (John Keller)
In-Reply-To: <20070628132343.2a15cc39.akpm@linux-foundation.org> from "Andrew Morton" at Jun 28, 2007 01:23:43 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Thu, 28 Jun 2007 13:09:21 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Thu, 28 Jun 2007 03:43:21 -0700 Andrew Morton wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> > 
> > 
> > on x86_64, with CONFIG_PCI disabled, CONFIG_PM disabled,
> > hence CONFIG_ACPI disabled:
> > 
> > 
> > arch/x86_64/kernel/built-in.o: In function `setup_IO_APIC':
> > (.init.text+0x4ef7): undefined reference to `mp_apic_pin_to_gsi'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> 
> hm, it's not immediately obvious how to fix that so I'll ask John to do
> repairs, please. 
> 

OK, I'll take a look.

John
