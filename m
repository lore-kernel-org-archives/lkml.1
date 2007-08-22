Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbXHVR1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbXHVR1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933219AbXHVR1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:27:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51613 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933144AbXHVR1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:27:38 -0400
Date: Wed, 22 Aug 2007 18:34:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822183431.133f056c@the-village.bc.nu>
In-Reply-To: <20070822175918.GB8058@bingen.suse.de>
References: <46CBC842.4070100@vmware.com>
	<20070822102217.GE2642@bingen.suse.de>
	<46CC68D9.5060200@vmware.com>
	<20070822175918.GB8058@bingen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> out is usually a single byte. Shouldn't be very expensive
> to decode. In fact it should be roughly equivalent to your
> hypercall multiplex.

Why is a performance critical path on a paravirt kernel even using I/O
instructions and not paravirtual device drivers ?

It clearly makes sense to virtualise I/O operations if you are doing that
(so you can do posting, triggers and predicted reply handling guest side
to keep the trap rate sane) but I don't see why this situation occurs in
the first place for paravirt.

