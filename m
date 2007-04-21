Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXDUG2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXDUG2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 02:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932710AbXDUG2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 02:28:21 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:42231 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbXDUG2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 02:28:20 -0400
Subject: Re: [PATCH 7/8] Kconfig: silicon backplane dependency.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org, linville@tuxdriver.com
In-Reply-To: <200704202245.43806.mb@bu3sch.de>
References: <20070420113505.GH3738@skybase>
	 <200704202245.43806.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Sat, 21 Apr 2007 08:28:33 +0200
Message-Id: <1177136913.25034.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 22:45 +0200, Michael Buesch wrote:
> This is wrong. SSB does not depend on PCI or PCMCIA.
> SSB can (and does) stay very well on its own feet and
> can be the main system bus.
> Most Linksys WRT routers work that way. They have no
> PCI bus, but a SSB bus instead.
> 
> Nevertheless, I'm not sure what your problem really is.
> Does a s390 machine exist with a B44 card? I doubt it.
> So what about the following: We simply add
> a DEPENDS ON !S390 to both SSB and B44.
> I really thing that is the right fix for this.
> The patch above is clearly not, as it breaks things for
> embedded devices without PCI or PCMCIA bus.

Ok, thanks. I will change the patch accordingly.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


