Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbXKTSDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbXKTSDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXKTSDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:03:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42753 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752453AbXKTSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:03:06 -0500
Date: Tue, 20 Nov 2007 18:00:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: trenn@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH 3/3] PNP cleanups - Version 2 - Pass struct pnp_dev to 
  pnp_clean_resource_table for cleanup reasons
Message-ID: <20071120180007.1ebe11a2@the-village.bc.nu>
In-Reply-To: <1195581124.23700.262.camel@queen.suse.de>
References: <1195581124.23700.262.camel@queen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 18:52:04 +0100
Thomas Renninger <trenn@suse.de> wrote:

> Pass struct pnp_dev to pnp_clean_resource_table for cleanup reasons

Again I don't see the point of this change. A routine for cleaning up
resource tables expects logically to be passed a resource table to clean
up not some device it may be attached to.

Perhaps if you could explain where you are trying to end up, it would
help understand what you are trying to do.

I don't see why pnp_dma() and pnp_irq() should change either. It just
causes noise and breaks driver code. I don't see where it needs to change
to make internal pnp changes work ?

Alan
