Return-Path: <linux-kernel-owner+w=401wt.eu-S1767122AbXDEP5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767122AbXDEP5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767125AbXDEP5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:57:04 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:42189 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767123AbXDEP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:56:58 -0400
X-Greylist: delayed 118695 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 11:56:58 EDT
Date: Thu, 5 Apr 2007 17:56:52 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Torben Mathiasen <torben@kernel.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       device@lanana.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
 optionally.
In-Reply-To: <1175784435.2719.18.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.64.0704051732460.17664@anakin>
References: <1175666635.2932.17.camel@shinybook.infradead.org>
 <17939.17962.248566.886449@cargo.ozlabs.ibm.com> <1175696383.2774.24.camel@shinybook.infradead.org>
 <20070405.233101.106261123.anemo@mba.ocn.ne.jp> <1175784435.2719.18.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, David Woodhouse wrote:
> On Thu, 2007-04-05 at 23:31 +0900, Atsushi Nemoto wrote
> > Is major 204 minor 192 already allocated?
> 
> Of course. The reason it took so long to provide this patch after the
> 'pmac_zilog doesn't load' bug got reported was because I was waiting for
> the new allocation.

What about the moratorium on newly assigned numbers?
What about using a dynamically allocated number?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
