Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZGIJaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZGIJaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZGIJaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:30:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54415 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZGIJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:30:11 -0400
Date: Thu, 9 Jul 2009 10:30:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
Message-ID: <20090709093004.GA32655@sirena.org.uk>
References: <cover.1247032324.git.joe@perches.com> <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com> <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com> <1247035197.5124.9.camel@Joe-Laptop.home> <1247035481.15919.31.camel@penberg-laptop> <1247035628.5124.11.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247035628.5124.11.camel@Joe-Laptop.home>
X-Cookie: Noone ever built a statue to a critic.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 11:47:08PM -0700, Joe Perches wrote:

> Well, if scripts/get_maintainer.pl gets used more often,
> it would.

FWIW I've noticed that get_maintainer.pl has a tendency to pick up
people it probably shouldn't when run on areas that have had few people
committing to them since it tends to pick up people who've done generic
cleanups but have no specific interest in that area of code.  I think a
heuristic based on filtering the git log based on the proportion of
commits that were done by each committer would help with many of these
cases.
