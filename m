Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbZIHOpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbZIHOpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZIHOpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:45:49 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42460 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZIHOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:45:49 -0400
Date: Tue, 8 Sep 2009 10:17:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
Subject: Re: iwlagn: order 2 page allocation failures
Message-ID: <20090908141701.GB2617@tuxdriver.com>
References: <200909060941.01810.elendil@planet.nl> <84144f020909060114s74de2d2y850745dd82ece753@mail.gmail.com> <200909061028.48442.elendil@planet.nl> <1252226116.11274.10.camel@penberg-laptop> <20090908105415.GD28127@csn.ul.ie> <84144f020909080411n4e010308qa153039bee1b8336@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020909080411n4e010308qa153039bee1b8336@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 02:11:35PM +0300, Pekka Enberg wrote:
> On Tue, Sep 8, 2009 at 1:54 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> > My feeling is also that a number of these page allocation failures have
> > been related to wireless drivers. Is that accurate? If so, have there
> > been changes made to the wireless stack in this cycle that would have
> > increased the order of pages allocated?
> 
> That's my general feeling as well. We have linux-wireless CC'd so
> maybe this rings a bell for them.

AFAIK, this is only the second separate report.  The other related
to ipw2200, which actually shares no code with the iwlagn driver and
is not based on the mac80211 stack.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
