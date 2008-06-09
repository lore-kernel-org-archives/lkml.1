Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFINy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFINy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYFINyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:54:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48524 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYFINyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:54:16 -0400
Date: Mon, 9 Jun 2008 14:53:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/7] mmc: at91_mci: add multiwrite switch
Message-ID: <20080609135356.GD30971@flint.arm.linux.org.uk>
References: <483FE9E7.7020707@atmel.com> <483FEE58.5000500@atmel.com> <20080601144251.GS5818@flint.arm.linux.org.uk> <20080609124249.349995df@mjolnir.drzeus.cx> <20080609130831.GC30971@flint.arm.linux.org.uk> <20080609154247.06db4c3e@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609154247.06db4c3e@mjolnir.drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 03:42:47PM +0200, Pierre Ossman wrote:
> You're still listed for the primecell driver though. What's the status
> on that one?

It's always reported the number of bytes transferred to/from the card
(which I think includes the wait for the busy signal to deassert.)

Probably the best thing is to mark MMCI as orphaned as well - for much
the same reason.  I've only one remaining MMC card which I use for
other purposes.  I'm not willing to sacrifice that one for further
testing, neither am I willing to buy another card to just be used for
testing purposes.
