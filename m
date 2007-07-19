Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbXGSNRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbXGSNRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757544AbXGSNRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:17:21 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45818 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbXGSNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:17:19 -0400
Date: Thu, 19 Jul 2007 09:17:18 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dor Laor <dor.laor@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070719131718.GC5623@csclub.uwaterloo.ca>
References: <005901c7c921$79c006c0$6d401440$@com> <20070718123040.615795b7@the-village.bc.nu> <64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net> <20070718174736.0baf6d0e@the-village.bc.nu> <469E43D5.70802@qumranet.com> <20070718191433.GB24545@csclub.uwaterloo.ca> <469F2D8C.7020805@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F2D8C.7020805@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 12:23:24PM +0300, Avi Kivity wrote:
> No, it means disallowing pci devices that use shared irqs, and allowing 
> pci devices that use non-shared irqs.

Most machiens I see today have almost no chance of having PCI devices
without shared IRQs.  This probably means any implementation will only
work on a small set of machines with very specific setup in terms of
which PCI slots they install cards in, and only as long as you don't
allow any type of hotplugging of devices (or ever changing hardware at
all).  May not be worth implementing if it has such a limited use case.
The MSI setup on the other hand does sound like it might have potential
for working in general.

> IMO pass-through is counter to most of the benefits of virtualization.  
> But users seem to want it.

Certainly if you can have the host manage the device and provide virutal
access instead, that is much better.

--
Len Sorensen
