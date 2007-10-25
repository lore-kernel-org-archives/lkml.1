Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbXJYPZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbXJYPZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759678AbXJYPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:25:05 -0400
Received: from www.tglx.de ([62.245.132.106]:37173 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758197AbXJYPZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:25:04 -0400
Date: Thu, 25 Oct 2007 17:24:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
In-Reply-To: <200710251430.03202.florian.fainelli@telecomint.eu>
Message-ID: <alpine.LFD.0.9999.0710251720420.3186@localhost.localdomain>
References: <200710181551.24912.florian.fainelli@telecomint.eu> <20071022151845.5874fba3@ephemeral> <alpine.LFD.0.9999.0710251013170.3186@localhost.localdomain> <200710251430.03202.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Florian Fainelli wrote:
> > It might be useful for everyone to check, whether the existing GPIO
> > functionality can be extended, reworked to match the needs of Geode as
> > well. Extending / reworking an existing interface is definitely
> > better than adding a new incompatible one.
> 
> Of course. Just because Geode is the only x86 potential user of such an API 
> does not mean it should impose its design. Remember that this patch is part 
> of a serie to add support for the RDC R-321x SoC, which becomes another 
> x86-family user.
> 
> Looking at what Geode can do, and what RDC can do, I guess there are only few 
> functions that are generic, all the drain, multiplexing, direction things are 
> only available on the Geode board.

It does not matter whether Geode has 500 functions and RDC has 5. It
matters that we do _not_ want two different APIs which deal with the
same thing, where one can obviously be a subset of the other. So
either we can extend / rework the stuff that both parties are happy or
we are not going to merge either of them.

       tglx


