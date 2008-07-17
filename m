Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYGQIvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYGQIvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYGQIvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:51:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:54091 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbYGQIvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:51:13 -0400
Subject: Re: [PATCH] Fix collateral damage to top level Makefile
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Mundt <lethal@linux-sh.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, petkovbb@googlemail.com,
       jrigby@freescale.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080717072731.GB12273@linux-sh.org>
References: <20080717070549.30755.13083.stgit@trillian.secretlab.ca>
	 <20080717072731.GB12273@linux-sh.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 18:50:24 +1000
Message-Id: <1216284624.7740.326.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 16:27 +0900, Paul Mundt wrote:
> On Thu, Jul 17, 2008 at 01:06:55AM -0600, Grant Likely wrote:
> > From: Grant Likely <grant.likely@secretlab.ca>
> > 
> > The patch named "powerpc/mpc5121: Add clock driver", also contained
> > an unrelated and bogus change to the top-level makefile.  This patch
> > backs out the bad bit.
> > 
> > SHA1 of offending patch: 137e95906e294913fab02162e8a1948ade49acb5)
> > 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > 
> > If the maintainer who picked up this patch (Grant Likely) had done
> > his job, this cack-up never would have happened.  Why do we still
> > have to deal with such sloppy individuals?
> > 
> I think the more important question is why the hell would anyone put that
> in a Makefile, ever? ;-)

Well, it's partially my fault for not spotting it when pulling in
Grant's git and pushing out to Linus.

Anyway, it's a mistake, shit happens, I doubt Grant will do that one
twice :-)

Cheers,
Ben.


