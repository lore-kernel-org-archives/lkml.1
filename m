Return-Path: <linux-kernel-owner+w=401wt.eu-S933493AbZHWJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbZHWJIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933485AbZHWJIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:08:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42564 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933484AbZHWJIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:08:16 -0400
Date: Sun, 23 Aug 2009 10:08:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Message-ID: <20090823090807.GB4589@sirena.org.uk>
References: <20090811223645.GA4691@sirena.org.uk>
 <20090814163201.GB1626@ucw.cz>
 <20090815164324.GA4252@sirena.org.uk>
 <20090815223434.GB27637@elf.ucw.cz>
 <20090816091858.GB12567@sirena.org.uk>
 <20090822092845.GE11448@elf.ucw.cz>
 <20090822101641.GC4344@sirena.org.uk>
 <20090821140126.GA1328@ucw.cz>
 <20090822141646.GA5812@sirena.org.uk>
 <20090822193515.GA15488@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090822193515.GA15488@elf.ucw.cz>
X-Cookie: Today is what happened to yesterday.
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

On Sat, Aug 22, 2009 at 09:35:15PM +0200, Pavel Machek wrote:

> Well, I'd like the older designs to work well too. (Actually, the

There's not likely to be implementing things like SBS, though.

> Dream... was on wifi when I got bad problems charging it from
> usb.... so maybe charging while suspended would not help there).

Radios are one of the biggest consumers of power, especially when
transmitting, 3G being particularly bad.  If the phone was sitting idle
it should've been fine but if it's actually using the WiFi I'd expect
that to slow down the charge.
