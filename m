Return-Path: <linux-kernel-owner+w=401wt.eu-S965494AbXDVHxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965494AbXDVHxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXDVHxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:53:30 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:10094 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965461AbXDVHx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:53:29 -0400
Subject: Re: [PATCH 7/8] Kconfig: silicon backplane dependency.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org, mb@bu3sch.de, linville@tuxdriver.com
In-Reply-To: <200704220119.32729.arnd@arndb.de>
References: <20070420113505.GH3738@skybase>
	 <200704220119.32729.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Sun, 22 Apr 2007 09:53:43 +0200
Message-Id: <1177228423.8046.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-22 at 01:19 +0200, Arnd Bergmann wrote:
> > diff -urpN linux-2.6/drivers/ssb/Kconfig linux-2.6-patched/drivers/ssb/Kconfig
> > --- linux-2.6/drivers/ssb/Kconfig       2007-04-19 15:24:40.000000000 +0200
> > +++ linux-2.6-patched/drivers/ssb/Kconfig       2007-04-19 15:55:44.000000000 +0200
> > @@ -1,4 +1,5 @@
> >  menu "Sonics Silicon Backplane"
> > +       depends on PCI || PCMCIA
> 
> No, this doesn't look right. There are other devices that come with
> SiliconBackplane but are not PCI or PCMCIA style devices.

Yes, Michael already told me about that. The current solution is to use
!S390, could we use HAS_IOMEM instead ?

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


