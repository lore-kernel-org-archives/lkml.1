Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbXGRQui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbXGRQui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbXGRQua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:50:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34279 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758068AbXGRQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:50:29 -0400
Date: Wed, 18 Jul 2007 17:57:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@qumranet.com>
Cc: Dor Laor <dor.laor@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070718175708.6968923e@the-village.bc.nu>
In-Reply-To: <469E43D5.70802@qumranet.com>
References: <005901c7c921$79c006c0$6d401440$@com>
	<20070718123040.615795b7@the-village.bc.nu>
	<64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net>
	<20070718174736.0baf6d0e@the-village.bc.nu>
	<469E43D5.70802@qumranet.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> IMO the only reasonable solution is to disallow interrupt forwarding
> with shared irqs.  If someone later comes up with a bright idea, we can

Which means you are back to ISA bus devices. Even checking if an IRQ is
currently unshared isn't simple as with hotplug this may change.

> implement it.  Otherwise the problem will solve itself with hardware
> moving to msi.

Only if MSI ever works properly on the bridges and hardware 8(
