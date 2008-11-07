Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYKGQIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYKGQIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYKGQIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:08:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56810 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754134AbYKGQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:08:19 -0500
Date: Fri, 7 Nov 2008 16:08:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Lee Howard <lee.howard@mainpine.com>,
       "'Peter Alfredsen'" <loki_val@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3
Message-ID: <20081107160801.5f0a4b42@lxorguk.ukuu.org.uk>
In-Reply-To: <20081106201501.GB28514@flint.arm.linux.org.uk>
References: <20081106174341.GA8155@xolotl.n0ano.com>
	<200811061952.37490.loki_val@gentoo.org>
	<20081106191250.GA28514@flint.arm.linux.org.uk>
	<AA46BE34D4E74CB69F948F36984126A9@callisto>
	<20081106201501.GB28514@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 20:15:01 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Thu, Nov 06, 2008 at 11:39:44AM -0800, Lee Howard wrote:
> > The "hack" originates from code done by Oxford Semiconductor.  I would be
> > happy to have it done with the quirk system, and I am willing to write a
> > patch to that effect.  My guess, however, would be that I'll still not do it
> > in your favorite way, and so I'm asking if you would like me to write the
> > code change or will you (or someone else here familiar with the favorite
> > ways) do it?
> 
> There's plenty of examples in there, eg, pci_timedia_init, pci_netmos_init,
> and pci_ite887x_init all have a variable number of ports.  Here's a patch
> which converts it:

Looks good to me but needs a Signed-off-by: line

Alan
