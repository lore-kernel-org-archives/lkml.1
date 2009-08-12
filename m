Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZHLWxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZHLWxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZHLWxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:53:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38577 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZHLWxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:53:24 -0400
Date: Wed, 12 Aug 2009 23:53:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org
Message-ID: <20090812225312.GD4731@sirena.org.uk>
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
 <20090811223645.GA4691@sirena.org.uk>
 <20090812064745.GA17285@gandalf>
 <20090812100517.GA11227@sirena.org.uk>
 <20090812190659.GA21001@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812190659.GA21001@gandalf>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Smart Battery System Design (was: Re: Question about
 userspace-consumer)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 10:07:03PM +0300, Felipe Balbi wrote:
> On Wed, Aug 12, 2009 at 11:05:17AM +0100, Mark Brown wrote:

> > You actually get notification on any change the supply chooses to notify
> > the core on IIRC.

> true, but that's only (at least on the chips I've seen) for the presence
> of the charger. I haven't seen a chip that notify you based on a
> threshold of e.g. voltage change or temperature change. Which would be a
> really nice feature: you could give a "best" temperature value and a
> threshold of +-10% and if that changes over that limit, device
> interrupts processor, or something like that.

If a chip has a generic AUX ADC (of the sort used for voltage
monitoring) it'll quite often also have some comparator functionality to
go along with it, normally configurable.
