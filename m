Return-Path: <linux-kernel-owner+w=401wt.eu-S1764830AbXGRRI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764830AbXGRRI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbXGRRIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:08:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57529 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbXGRRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:08:21 -0400
Date: Wed, 18 Jul 2007 18:14:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@qumranet.com>
Cc: Dor Laor <dor.laor@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070718181459.717ba4ad@the-village.bc.nu>
In-Reply-To: <469E4679.205@qumranet.com>
References: <005901c7c921$79c006c0$6d401440$@com>
	<20070718123040.615795b7@the-village.bc.nu>
	<64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net>
	<20070718174736.0baf6d0e@the-village.bc.nu>
	<469E43D5.70802@qumranet.com>
	<20070718175708.6968923e@the-village.bc.nu>
	<469E4679.205@qumranet.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hotplug is user-controllable, so if the user refrains from adding pci
> devices after assigning a device to the guest, it should work.  I think
> that USB interrupts are assigned to the controller, not the device, so
> USB hotplug can be ruled out.

Cardbus is more problematic.

Alan
