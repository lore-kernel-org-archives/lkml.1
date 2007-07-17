Return-Path: <linux-kernel-owner+w=401wt.eu-S933427AbXGQTay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbXGQTay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757662AbXGQTar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:30:47 -0400
Received: from waste.org ([66.93.16.53]:37286 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbXGQTaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:30:46 -0400
Date: Tue, 17 Jul 2007 14:30:28 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070717193028.GF11166@waste.org>
References: <469A8AED.7070207@nerdgrounds.com> <Pine.LNX.4.64.0707171240040.686@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707171240040.686@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 12:59:03PM +0200, Jan Engelhardt wrote:
> 
> On Jul 15 2007 14:00, Jonathan Campbell wrote:
> >
> > These patches were written against the vanilla 2.6.21.1 kernel. They will have
> > no effect UNLESS you make menuconfig and explicitly enable them there.
> >
> >
> inline patches...
> 
> >+config X86_DONT_CPUID
> >+	bool "Disable CPUID support"
> >+	depends on M386 || M486
> 
> I think this should not depend on any model.
> Depend on x86 at best.

Indeed.
 
> 	depends on X86
> 
> >+	default n
> 
> And perhaps it would be helpful to invert it, like the other options, i.e.:
> 
> config X86_CPUID
> 	bool "Enable CPUID support" if X86 && EMBEDDED
> 	default y

Definitely.

-- 
Mathematics is the supreme nostalgia of our time.
