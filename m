Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYFINJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYFINJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbYFINJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:09:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60157 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681AbYFINJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:09:03 -0400
Date: Mon, 9 Jun 2008 14:08:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/7] mmc: at91_mci: add multiwrite switch
Message-ID: <20080609130831.GC30971@flint.arm.linux.org.uk>
References: <483FE9E7.7020707@atmel.com> <483FEE58.5000500@atmel.com> <20080601144251.GS5818@flint.arm.linux.org.uk> <20080609124249.349995df@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609124249.349995df@mjolnir.drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 12:42:49PM +0200, Pierre Ossman wrote:
> On Sun, 1 Jun 2008 15:42:52 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > If Pierre wants to remove the MULTIWRITE flag, I'd like to hear his
> > solution for the pxamci driver, where the only way to ascertain how
> > many bytes were transmitted may be to walk the SG list comparing the
> > DMA pointer with what was in the hardware DMA engine at the time.
> > Maybe.
> 
> You set bytes_xfered to 0. As mentioned in my previous mail, I had a
> chat with Jens about this and upper layers can only expect to get the
> lower bound in how many bytes were written. Other hardware/drivers
> already behaves like this so there is no point in crippling the MMC
> layer in an effort to give nicer guarantees.
> 
> This is why I asked people to audit their drivers to make sure it's
> the lower bound that's returned, but I've not received much in the way
> of replies.

You won't do from me concerning pxamci - I don't look after it anymore
after one of my MMC cards got eaten by the misbehaving bugger.  I don't
think anyone else is looking after it, so that means the driver's
effectively unmaintained.
