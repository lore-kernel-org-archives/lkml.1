Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZGJSo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZGJSo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZGJSoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:44:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49378 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZGJSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:44:19 -0400
Date: Fri, 10 Jul 2009 19:44:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Message-ID: <20090710184409.GB4136@sirena.org.uk>
References: <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
 <1247035197.5124.9.camel@Joe-Laptop.home>
 <1247035481.15919.31.camel@penberg-laptop>
 <1247035628.5124.11.camel@Joe-Laptop.home>
 <20090709093004.GA32655@sirena.org.uk>
 <1247151536.12426.39.camel@Joe-Laptop.home>
 <20090709150810.GA25112@rakim.wolfsonmicro.main>
 <1247168139.3461.2.camel@Joe-Laptop.home>
 <20090710131742.GB8878@rakim.wolfsonmicro.main>
 <1247243100.11673.58.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247243100.11673.58.camel@Joe-Laptop.home>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 09:25:00AM -0700, Joe Perches wrote:
> On Fri, 2009-07-10 at 14:17 +0100, Mark Brown wrote:

> > That seems reasonably effective with 5% or so as the default.  I do
> > think the default should be non-zero if we're going to be encouraging
> > people to use this as standard, though.

> I'm not sure minimization of maintainers in
> the result is that desirable but I am for
> figuring out what works best.

It's not so much minimising maintainers per se that I'm concerned about
as ensuring that people doing general cleanup work don't end up getting
CCed on lots of random stuff, partly for their benefit and partly to
make get_maintainers easier to use.

> What have you experimented with and how have the
> results changed?

A combination of patches I'm working on and source files in subsystems I
maintain (basically, stuff where I know off the top of my head who
should turn up).  The noticable issues are things like Jean Delvare
turning up for sound/soc/codecs/tlv320aic3x.c as a result of kernel wide
API update work he was doing - by tweaking the percentage I was able to
get the output to exclude people who I know have done non-specific
cleanup work.
