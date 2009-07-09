Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbZGIPIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbZGIPIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbZGIPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:08:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53312 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752083AbZGIPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:08:12 -0400
Date: Thu, 9 Jul 2009 16:08:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 5/7] MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
Message-ID: <20090709150810.GA25112@rakim.wolfsonmicro.main>
References: <cover.1247032324.git.joe@perches.com>
 <9c84258bdd3ebecd54e2bc203dbded1382af9c02.1247032324.git.joe@perches.com>
 <84144f020907072332h4f0cdc16lfed34f6509782394@mail.gmail.com>
 <1247035197.5124.9.camel@Joe-Laptop.home>
 <1247035481.15919.31.camel@penberg-laptop>
 <1247035628.5124.11.camel@Joe-Laptop.home>
 <20090709093004.GA32655@sirena.org.uk>
 <1247151536.12426.39.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247151536.12426.39.camel@Joe-Laptop.home>
X-Cookie: try again
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 07:58:56AM -0700, Joe Perches wrote:
> On Thu, 2009-07-09 at 10:30 +0100, Mark Brown wrote:

> > cleanups but have no specific interest in that area of code.  I think a
> > heuristic based on filtering the git log based on the proportion of
> > commits that were done by each committer would help with many of these
> > cases.

> git log "-by:" lines are already sorted by number of commits
> before selecting maintainers.  It doesn't matter if the
> line is acked-by:, Signed-off-by:, tested-by:, or
> brown-paper-bagged-by:, any "by:" signature is used.

Yup, I'm aware of that.

> I suppose when the number of committers returned by
> the "git log | grep" is low, returning just the 
> most frequent committers might be good.

> Any suggestions on better heuristics?

That's pretty much what I was thinking of too - tweaking the values for
the log queries based on the total number of hits so people only turn up
if they did a certain proportion of the commits.  It'd take some
experimentation to work out what the values to use should be, I guess.
