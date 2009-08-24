Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbZHXFrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbZHXFrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 01:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZHXFrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 01:47:41 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:49208 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZHXFrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 01:47:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=bFD1lasMFVVNA5OJtLVK//v0E1LrOH2LrmN3p6d0CuO0ERuUdOgqXtvEi9AE/mq8U9
         q7Tn8Dc96n5nPjtFIpK66LVAk8Pvd2FmOsKlBD9xyAi1JBxIo4wa7tKt2gJfeDlvpQSc
         DHb0dsBJzUe7gXT9vIHlaC9iXAqnc/uJVoHtM=
Date: Mon, 24 Aug 2009 08:49:20 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [RFC][PATCH 1/3 v2] ARM: OMAP: DMA: Add support
 for DMA channel self linking on OMAP1510
Message-Id: <20090824084920.c99c561a.jhnikula@gmail.com>
In-Reply-To: <20090823184943.GA6994@opensource.wolfsonmicro.com>
References: <200908101050.02530.jkrzyszt@tis.icnet.pl>
	<200908231945.40187.jkrzyszt@tis.icnet.pl>
	<20090823180543.GA6167@opensource.wolfsonmicro.com>
	<200908232038.05593.jkrzyszt@tis.icnet.pl>
	<20090823184943.GA6994@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009 19:49:43 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Sun, Aug 23, 2009 at 08:38:05PM +0200, Janusz Krzysztofik wrote:
> > Sunday 23 August 2009 20:05:43 Mark Brown wrote:
> 
> > > then what are the other 
> > > patches that depend on this? Nobody reported any issues in testing with 
> > > the other OMAP patches.
> 
> > Dependency on patch 1/3 is not compile time, but run time, and OMAP1510 
> > specific, that's probably why nobody has reported any issues.
> 
> OK, given that and the fact that you're reporting that none of these
> files are afected by any of the other patches it sounds like it'd be
> better to keep it in the OMAP tree unless Tony says otherwse.

Yep, Janusz's commits 64844a6ac8ddd586cb832fea7cf2e93e5e7e03f4 and
471e3dec3abe2d41e8c742046353fcb01bc2459e do not cause problems on other
OMAPs but will cause that ASoC on 1510 is broken until his DMA
patch(es) are applied. I'm sure you Janusz will ping Tony until he'll
apply them :-)

We should remember that arch/arm/plat-omap/mcbsp.c changes done via
ALSA tree has been an exception and that's only for simpler procedure.
McBSP is not so critical if sources goes out-of-sync but DMA is.


-- 
Jarkko
