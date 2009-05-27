Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZE0Uig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZE0Uig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZE0Ui2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:38:28 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:45427 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751887AbZE0Ui1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:38:27 -0400
Date: Wed, 27 May 2009 22:27:01 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: David Miller <davem@davemloft.net>
Cc: rmk+lkml@arm.linux.org.uk, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, timur@freescale.com,
       scottwood@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527202701.GA16219@game.jcrosoft.org>
References: <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <20090527.132328.78091350.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527.132328.78091350.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Ovh-Tracer-Id: 11871207144491494181
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.500005/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:23 Wed 27 May     , David Miller wrote:
> From: Russell King <rmk+lkml@arm.linux.org.uk>
> Date: Wed, 27 May 2009 20:29:10 +0100
> 
> > To program them into the hardware registers, which is not what we in
> > the ARM community say, but it's what the _network_ guys tell people
> > they should be doing.
> > 
> > I've suggested in the past having a standard kernel parameter such
> > that you can specify a mac address on a per-device basis in a totally
> > platform independent way, but the network folk don't like that idea.
> 
> As a "network guy" I can tell you that when the system firmware
> provides a system-wide or device specific MAC address in it's device
> tree, that is what you should use.
> 
> And that's what I've been doing on sparc FOR 15 YEARS.
> 
> Device trees are the only systematic generic mechanism for
> describing device layouts on the myriad of embedded boards
> out there which you will ever find.
> 
> Two platforms, and now a third, have been using this scheme
> over a very proven period of time.  It's not a hack, there is
> infrastructure to get the boot loaders to do the right thing,
> and only ARM seems to resist it. :-)
The SH, avr32, mips, x86 does not support it too IIRC

Best Regards,
J.
