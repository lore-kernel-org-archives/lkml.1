Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYGOM6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYGOM6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYGOM6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:58:45 -0400
Received: from tim.rpsys.net ([194.106.48.114]:41461 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbYGOM6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:58:45 -0400
Subject: Re: [PATCH v2] leds: implement OpenFirmare GPIO LED driver
From: Richard Purdie <rpurdie@rpsys.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20080715124013.GA13086@polina.dev.rtsoft.ru>
References: <20080715123822.GA10893@polina.dev.rtsoft.ru>
	 <20080715124013.GA13086@polina.dev.rtsoft.ru>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 13:54:30 +0100
Message-Id: <1216126470.5345.55.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 16:40 +0400, Anton Vorontsov wrote:
> Despite leds-gpio and leds-of-gpio similar names and purposes, there
> is not much code can be shared between the two drivers (both are mostly
> driver bindings anyway).

I don't have any issue with the driver itself, just the name which is
going to confuse people no end.

Can we come up with a better name for this driver please?
"dts-bind-gpio"? "openfirmware-led"?

I'm mainly concerned with the more user visible bits like the name of
the .c file, the wording of the Kconfig option and the module
description. We need to play down the GPIO bit and play up the
openfirmware bindings bit.

As an example the Kconfig says "LED Support for GPIO connected LEDs"
which its not, the bit about openfirmware bindings is in brackets and
hence looks incidental.

Cheers,

Richard


