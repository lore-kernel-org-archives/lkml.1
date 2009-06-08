Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZFHO63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZFHO63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZFHO6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:58:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50128 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbZFHO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:58:18 -0400
Date: Mon, 8 Jun 2009 15:58:16 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for
	VIA/Centaur CPUs
Message-ID: <20090608145816.GA17579@srcf.ucam.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906060856.15016.lkml@morethan.org> <20090608102754.GP4106@prithivi.gnumonks.org> <200906080925.12460.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906080925.12460.lkml@morethan.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:25:09AM -0500, Michael S. Zick wrote:
> On Mon June 8 2009, Harald Welte wrote:
> > The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
> > using a MSR interface.  The Linux driver just never made use of it, since in
> > addition to the check for the EST flag it also checked if the vendor is Intel.
> >
> 
> It looks like we should modify (conditional on ...MVIAC7 at build, model='d' runtime)
> the acpi-cpufreq controls to deal properly with the Model-D adaptive controller.

Can't make it build-time dependent - distribution kernels may not 
explicitly support the C7. It's valid to have a vendor=centaur 
conditional that turns off any adaptive control if appropriate ACPI 
methods are present.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
