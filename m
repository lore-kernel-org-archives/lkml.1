Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZGJNRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZGJNRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZGJNRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:17:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57630 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751778AbZGJNRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:17:44 -0400
Date: Fri, 10 Jul 2009 14:17:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
Message-ID: <20090710131742.GB8878@rakim.wolfsonmicro.main>
References: <cover.1247032324.git.joe@perches.com>
 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
 <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
 <1247035197.5124.9.camel@Joe-Laptop.home>
 <1247035481.15919.31.camel@penberg-laptop>
 <1247035628.5124.11.camel@Joe-Laptop.home>
 <20090709093004.GA32655@sirena.org.uk>
 <1247151536.12426.39.camel@Joe-Laptop.home>
 <20090709150810.GA25112@rakim.wolfsonmicro.main>
 <1247168139.3461.2.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247168139.3461.2.camel@Joe-Laptop.home>
X-Cookie: Try
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 12:35:39PM -0700, Joe Perches wrote:
> On Thu, 2009-07-09 at 16:08 +0100, Mark Brown wrote:

> > That's pretty much what I was thinking of too - tweaking the values for
> > the log queries based on the total number of hits so people only turn up
> > if they did a certain proportion of the commits.  It'd take some
> > experimentation to work out what the values to use should be, I guess.

> Perhaps something like this:

> +    --git-min-percent => minimum percentage of commits required (default: 0)

That seems reasonably effective with 5% or so as the default.  I do
think the default should be non-zero if we're going to be encouraging
people to use this as standard, though.
