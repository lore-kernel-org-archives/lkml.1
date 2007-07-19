Return-Path: <linux-kernel-owner+w=401wt.eu-S938866AbXGSQYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938866AbXGSQYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760316AbXGSQXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:23:52 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60732 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbXGSQXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:23:51 -0400
Date: Thu, 19 Jul 2007 12:23:50 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dor Laor <dor.laor@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070719162350.GD5623@csclub.uwaterloo.ca>
References: <005901c7c921$79c006c0$6d401440$@com> <20070718123040.615795b7@the-village.bc.nu> <64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net> <20070718174736.0baf6d0e@the-village.bc.nu> <469E43D5.70802@qumranet.com> <20070718191433.GB24545@csclub.uwaterloo.ca> <469F2D8C.7020805@qumranet.com> <20070719131718.GC5623@csclub.uwaterloo.ca> <469F6941.9010901@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F6941.9010901@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 04:38:09PM +0300, Avi Kivity wrote:
> Looking at two random servers here and a desktop, interrupts are 
> unshared except for usb.  A laptop was not so lucky.  So "no chance" is 
> a bit extreme.
> 
> I agree it's far from optimal, but it is less limited than you imply.

Well with 4 PCI interrupts, it doesn't take that many PCI devices before
you must be sharing.  Of course it seems some higher end systems split
up the PCI bus in some way and run different IRQs from the APIC to
different slots.  I suspect that is how I see IRQ's of 177, 185, 193,
201, 209, etc on some systems.

If you have a server with an IO APIC then I suppose you have a rather
good chance of avoiding shared IRQs for the most part.

--
Len Sorensen
