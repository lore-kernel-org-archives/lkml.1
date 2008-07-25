Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYGYHvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYGYHvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYGYHv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:51:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:46109 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYGYHv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:51:27 -0400
Subject: Re: sfx.c driver build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Michael Brown <mbrown@fensystems.co.uk>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <Pine.LNX.4.62.0807250831440.8217@dolphin.home>
References: <1216966559.11188.85.camel@pasglop>
	 <Pine.LNX.4.62.0807250831440.8217@dolphin.home>
Content-Type: text/plain; charset=utf-8
Date: Fri, 25 Jul 2008 17:50:57 +1000
Message-Id: <1216972257.11188.96.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 08:35 +0100, Michael Brown wrote:
> On Fri, 25 Jul 2008, Benjamin Herrenschmidt wrote:
> > The sfx driver (which happens to be part of some of our test configs) 
> > fails to build in current Linus tree on powerpc with this error:
> > 
> > /home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c: In function ÿÿefx_probe_interruptsÿÿ:
> > /home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c:845: error: lvalue required as unary ÿÿ&ÿÿ oper
> > and
> 
> I'm not the maintainer of that code; I wrote the original version, but 
> it's now maintained by Solarflare.
> 
> I don't see anything on that line that ought to be architecture-specific.  
> Could you send me the preprocessed efx.c from your powerpc build?

Apparently, it's a know generic breakage of the topology stuff,
it's beeing sorted out.

Cheers,
Ben.


