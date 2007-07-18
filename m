Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbXGRTOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbXGRTOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXGRTOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:14:34 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:57153 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbXGRTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:14:34 -0400
Date: Wed, 18 Jul 2007 15:14:33 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dor Laor <dor.laor@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070718191433.GB24545@csclub.uwaterloo.ca>
References: <005901c7c921$79c006c0$6d401440$@com> <20070718123040.615795b7@the-village.bc.nu> <64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net> <20070718174736.0baf6d0e@the-village.bc.nu> <469E43D5.70802@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E43D5.70802@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 07:46:13PM +0300, Avi Kivity wrote:
> IMO the only reasonable solution is to disallow interrupt forwarding
> with shared irqs.  If someone later comes up with a bright idea, we can
> implement it.  Otherwise the problem will solve itself with hardware
> moving to msi.

Disallowing shared IRQs means disallowing PCI devices in general, so now
you are back to ISA only devices, which it sounds like were the only
things already allowed by vm86 or whatever it was for passing through.

MSI would be good, but how long until all devices support that?
Certainly does appear to have potential though for allowing more
interesting virtual machines.

--
Len Sorensen
