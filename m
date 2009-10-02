Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbZJBOi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbZJBOi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbZJBOi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:38:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59386 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931AbZJBOiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:38:55 -0400
Date: Fri, 2 Oct 2009 15:38:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mike Frysinger <vapier@gentoo.org>,
       tglx@linutronix.de, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520
	MultifunctionLCDBacklight and Keypad Input Device Driver
Message-ID: <20091002143851.GD11133@sirena.org.uk>
References: <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com> <8A42379416420646B9BFAC9682273B6D0E33B1AA@limkexm3.ad.analog.com> <20091002142725.GC11133@sirena.org.uk> <8A42379416420646B9BFAC9682273B6D0E33B2B6@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E33B2B6@limkexm3.ad.analog.com>
X-Cookie: Zeus gave Leda the bird.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 03:37:15PM +0100, Hennerich, Michael wrote:

> So I guess your patch won't work on 2.6.31

Yes, it doesn't work in 2.6.31 - I waited until the relevant genirq
stuff had hit mainline before I submitted it.

> >This is essentially what a threaded IRQ handler does with current
> >mainline.  There were issues in 2.6.31 but I believe all Thomas' fixes
> >have been merged now.

> Do you know when they merged?
> They are not in latest staple 2.6.31.1.

2.6.32.
