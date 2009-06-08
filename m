Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbZFHPIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbZFHPIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZFHPIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:08:09 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:47431 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbZFHPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:08:08 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur CPUs
Date: Mon, 8 Jun 2009 10:08:04 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906080925.12460.lkml@morethan.org> <20090608145816.GA17579@srcf.ucam.org>
In-Reply-To: <20090608145816.GA17579@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081008.07994.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon June 8 2009, Matthew Garrett wrote:
> On Mon, Jun 08, 2009 at 09:25:09AM -0500, Michael S. Zick wrote:
> > On Mon June 8 2009, Harald Welte wrote:
> > > The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
> > > using a MSR interface.  The Linux driver just never made use of it, since in
> > > addition to the check for the EST flag it also checked if the vendor is Intel.
> > >
> > 
> > It looks like we should modify (conditional on ...MVIAC7 at build, model='d' runtime)
> > the acpi-cpufreq controls to deal properly with the Model-D adaptive controller.
> 
> Can't make it build-time dependent - distribution kernels may not 
> explicitly support the C7. It's valid to have a vendor=centaur 
> conditional that turns off any adaptive control if appropriate ACPI 
> methods are present.
> 

A valid point.

I haven't looked yet, but I think we have advanced to the point where the
'VIA hack' for cache-line size can also go away.
Now that the pci-cache-line-size setting is being done differently.
(currently a proposed change).

The C7(xxxx) is 99 44/100% a Pentium-M with minor differences.
(Like the power/thermal/freq adaptive controller on the "D" models.)

Mike

