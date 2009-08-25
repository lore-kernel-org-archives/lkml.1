Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZHYOYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZHYOYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZHYOYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:24:02 -0400
Received: from smtp.nokia.com ([192.100.122.233]:32516 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbZHYOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:24:01 -0400
Subject: Re: [PATCH v2 0/6] Device table matching for SPI subsystem
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: avorontsov@ru.mvista.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20090818214440.GA21391@oksana.dev.rtsoft.ru>
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
	 <1249889723.19638.13.camel@localhost>
	 <20090818214440.GA21391@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Aug 2009 17:14:04 +0300
Message-Id: <1251209644.3514.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Aug 2009 14:14:21.0823 (UTC) FILETIME=[5791B0F0:01CA258E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 01:44 +0400, Anton Vorontsov wrote:
> On Mon, Aug 10, 2009 at 10:35:23AM +0300, Artem Bityutskiy wrote:
> > On Fri, 2009-07-31 at 04:39 +0400, Anton Vorontsov wrote:
> > > Andrew,
> > > 
> > > This new patch set overwrites following patches:
> > > 
> > >   hwmon-lm70-convert-to-device-table-matching.patch
> > >   hwmon-adxx-convert-to-device-table-matching.patch
> > >   spi-merge-probe-and-probe_id-callbacks.patch
> > >   spi-prefix-modalias-with-spi.patch
> > >   of-remove-stmm25p40-alias.patch
> > >   mtd-m25p80-convert-to-device-table-matching.patch
> > >   spi-add-support-for-device-table-matching.patch
> > 
> > Are you going to send v3 and address David's comments?
> 
> No v3, but I'm going to address David's comments in a follow up
> patch set where I'll change the probing code anyway.
> 
> > Do you want some of these patches to go via the MTD tree or
> > they better go as a series via some other tree?
> 
> Um.. The MTD patches depend on SPI subsystem changes... If
> David and Andrew are OK with SPI patches going through MTD tree,
> then I'm fine with it as well.

If you are not sure, then I suggest to make these go through something
else (not MTD tree).

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

