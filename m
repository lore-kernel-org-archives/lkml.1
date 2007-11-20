Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbXKTMdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbXKTMdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbXKTMdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:33:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36480 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757407AbXKTMdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:33:12 -0500
Date: Tue, 20 Nov 2007 12:31:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: trenn@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] PNP cleanups - Unify the pnp macros to access
 resources in the pnp resource table
Message-ID: <20071120123102.03bdaa67@the-village.bc.nu>
In-Reply-To: <1195552283.23700.166.camel@queen.suse.de>
References: <1195552283.23700.166.camel@queen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 10:51:23 +0100
Thomas Renninger <trenn@suse.de> wrote:

> Unify the pnp macros to access resources in the pnp resource table

NAK

> port, mem, dma and irq resource macros are now all used in the same
> way. This is the basis (or makes it at least easier) for changing how
> the resources are allocated for memory optimizations.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>

I really don't like this change.

_start implies an _end and an _len. IRQs have none of those features, nor
are they ranges.

Alan
