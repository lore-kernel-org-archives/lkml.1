Return-Path: <linux-kernel-owner+w=401wt.eu-S1161458AbXDWL1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161458AbXDWL1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161450AbXDWL1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:27:41 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:53182 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161411AbXDWL1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:27:40 -0400
Subject: Re: [PATCH 7/8] Kconfig: silicon backplane dependency.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
In-Reply-To: <200704231322.36970.arnd@arndb.de>
References: <20070420113505.GH3738@skybase>
	 <200704221146.11439.mb@bu3sch.de> <1177327011.5984.10.camel@localhost>
	 <200704231322.36970.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Mon, 23 Apr 2007 13:27:56 +0200
Message-Id: <1177327676.5984.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 13:22 +0200, Arnd Bergmann wrote:
> > The current Kconfig code does not check all select statements if they
> > can be enabled before allowing the config option that does the select.
> > So the rule for using select statements is that the depends line of the
> > config option that selects another config option needs to be at least as
> > restrictive as the depends line of the selected option. Hence I'll add
> > the HAS_IOMEM depends to B44 as well. Okay ?
> 
> Isn't B44 already behind a WIRELESS or IEEE80211 or similar option that
> can't be selected on s390?

No, the option can be found in drivers/net/Kconfig under menu "Ethernet
(10 or 100Mbit)".

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


