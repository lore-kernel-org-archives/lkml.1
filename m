Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXKTPQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXKTPQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXKTPQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:16:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34186 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756840AbXKTPQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:16:12 -0500
Date: Tue, 20 Nov 2007 15:14:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: trenn@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] PNP cleanups - Unify the pnp macros to access
 resources in the pnp resource table
Message-ID: <20071120151404.4332d0d4@the-village.bc.nu>
In-Reply-To: <1195568360.23700.202.camel@queen.suse.de>
References: <1195552283.23700.166.camel@queen.suse.de>
	<20071120123102.03bdaa67@the-village.bc.nu>
	<1195568360.23700.202.camel@queen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> At the end is some example code how things could get even more cleaned
> up. It shows how I think pnp layer and one example driver would get

Your example adds rather than removes code.

> If this is not an option, please advise how to move on here:
> Still use struct resources for dma and irq, but just do not name it
> _start, but name the macro pnp_irq_no?

Is it actually even worth changing in the first place ? You seem to be
complicating the code not simplyifying it, and at the end of the day
ISAPnP is obsolete and BIOS PnP is obsoleted by ACPI

Alan
