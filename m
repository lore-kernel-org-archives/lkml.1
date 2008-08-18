Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYHRU1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYHRU1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYHRU0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:26:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYHRU0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:26:52 -0400
Date: Mon, 18 Aug 2008 13:25:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: andi@lisas.de, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, stable@kernel.org
Subject: Re: [git pull?] clocksource: ACPI pmtmr bugfixes [Was: Re: ACPI
 PM-Timer on K6-3 SiS5591: Houston...]
Message-Id: <20080818132546.0dfcbf77.akpm@linux-foundation.org>
In-Reply-To: <20080818200916.GA18209@comet.dominikbrodowski.net>
References: <20080818121924.6b61f7af.akpm@linux-foundation.org>
	<20080818193517.GA22097@isilmar.linta.de>
	<20080818200017.GA11247@rhlx01.hs-esslingen.de>
	<20080810101730.GA10024@rhlx01.hs-esslingen.de>
	<20080810162920.GA9860@comet.dominikbrodowski.net>
	<20080810190759.GA1879@rhlx01.hs-esslingen.de>
	<20080818190325.GA12581@comet.dominikbrodowski.net>
	<20080818121924.6b61f7af.akpm@linux-foundation.org>
	<20080818193517.GA22097@isilmar.linta.de>
	<20080818124755.162f24d1.akpm@linux-foundation.org>
	<20080818200916.GA18209@comet.dominikbrodowski.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 22:09:16 +0200
Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> Hi,
> 
> > Could I trouble you to resend them as plain-old-patches, with full
> > changelogs along with your thoughts about the suitablity for
> > 2.6.2[5678].x please?
> 
> patches will be sent as replies to this message. Thanks for taking care of
> this; I should have written more meaningful texts. Also, I failed to
> remember the second patch hasn't been tested yet ..
> 
> On Mon, Aug 18, 2008 at 10:00:17PM +0200, Andreas Mohr wrote:
> > I wanted to test your 2nd patch (improved init), but was unable to do so
> > (currently too busy due to large changes, plus distance to production system,
> > downtime NOT appreciated ;).
> 
> .. but still I think this is stuff for 2.6.27; not (yet) suitable for 2.6.26
> and 2.6.25 based on the -stable rules.
> 

(cc stable)

OK, thanks.  I tagged these as

Cc: <stable@kernel.org>         [2.6.26.x, 2.6.25.x but not immediately]

which is a bit rubbery.  What do you think are the criteria for
deciding when these are ready for the backports?  Something like "after
2.6.28-rc1 if nothing blew up"?


