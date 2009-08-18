Return-Path: <linux-kernel-owner+w=401wt.eu-S1751315AbZHRVol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbZHRVol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZHRVol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:44:41 -0400
Received: from ru.mvista.com ([213.79.90.228]:43925 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802AbZHRVok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:44:40 -0400
Date: Wed, 19 Aug 2009 01:44:40 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2 0/6] Device table matching for SPI subsystem
Message-ID: <20090818214440.GA21391@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
 <1249889723.19638.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1249889723.19638.13.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 10:35:23AM +0300, Artem Bityutskiy wrote:
> On Fri, 2009-07-31 at 04:39 +0400, Anton Vorontsov wrote:
> > Andrew,
> > 
> > This new patch set overwrites following patches:
> > 
> >   hwmon-lm70-convert-to-device-table-matching.patch
> >   hwmon-adxx-convert-to-device-table-matching.patch
> >   spi-merge-probe-and-probe_id-callbacks.patch
> >   spi-prefix-modalias-with-spi.patch
> >   of-remove-stmm25p40-alias.patch
> >   mtd-m25p80-convert-to-device-table-matching.patch
> >   spi-add-support-for-device-table-matching.patch
> 
> Are you going to send v3 and address David's comments?

No v3, but I'm going to address David's comments in a follow up
patch set where I'll change the probing code anyway.

> Do you want some of these patches to go via the MTD tree or
> they better go as a series via some other tree?

Um.. The MTD patches depend on SPI subsystem changes... If
David and Andrew are OK with SPI patches going through MTD tree,
then I'm fine with it as well.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
