Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZHOQne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZHOQne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZHOQne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:43:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41209 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZHOQnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:43:33 -0400
Date: Sat, 15 Aug 2009 17:43:24 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Message-ID: <20090815164324.GA4252@sirena.org.uk>
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
 <20090811223645.GA4691@sirena.org.uk>
 <20090814163201.GB1626@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814163201.GB1626@ucw.cz>
X-Cookie: Multics is security spelled sideways.
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

On Fri, Aug 14, 2009 at 06:32:01PM +0200, Pavel Machek wrote:

> Please don't put basic fastcharge logic to userspace:

> * you still want to fastcharge at init=/bin/bash boot

> * you want to fastcharge while machine is in s2ram. See spitz. Doing
>   that with userspace would be quite tricky.

Depending on the technologies involved and how well integrated the power
path management is with the battery charger fast charge during suspend
may not actually be desirable.  Some systems need or desire active
thermal management of the system from the CPU during fast charge.
