Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbZE0UXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbZE0UXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZE0UXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:23:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53289
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193AbZE0UX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:23:29 -0400
Date: Wed, 27 May 2009 13:23:28 -0700 (PDT)
Message-Id: <20090527.132328.78091350.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: scottwood@freescale.com, jacmet@sunsite.dk, r.schwebel@pengutronix.de,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, yuan-bo.ye@motorola.com,
       timur@freescale.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090527192909.GA32398@flint.arm.linux.org.uk>
References: <20090527175609.GB31861@flint.arm.linux.org.uk>
	<4A1D8FBA.6040802@freescale.com>
	<20090527192909.GA32398@flint.arm.linux.org.uk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Wed, 27 May 2009 20:29:10 +0100

> To program them into the hardware registers, which is not what we in
> the ARM community say, but it's what the _network_ guys tell people
> they should be doing.
> 
> I've suggested in the past having a standard kernel parameter such
> that you can specify a mac address on a per-device basis in a totally
> platform independent way, but the network folk don't like that idea.

As a "network guy" I can tell you that when the system firmware
provides a system-wide or device specific MAC address in it's device
tree, that is what you should use.

And that's what I've been doing on sparc FOR 15 YEARS.

Device trees are the only systematic generic mechanism for
describing device layouts on the myriad of embedded boards
out there which you will ever find.

Two platforms, and now a third, have been using this scheme
over a very proven period of time.  It's not a hack, there is
infrastructure to get the boot loaders to do the right thing,
and only ARM seems to resist it. :-)
