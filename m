Return-Path: <linux-kernel-owner+w=401wt.eu-S965496AbXDVHuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496AbXDVHuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965483AbXDVHuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:50:20 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:2604 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965475AbXDVHuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:50:17 -0400
Subject: Re: [PATCH 2/8] Kconfig: unwanted menus for s390.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <200704220232.10219.arnd@arndb.de>
References: <20070420113248.GC3738@skybase>
	 <200704220110.54587.arnd@arndb.de>  <200704220232.10219.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Sun, 22 Apr 2007 09:50:32 +0200
Message-Id: <1177228232.8046.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-22 at 02:32 +0200, Arnd Bergmann wrote:
> I just saw that we already have an option like that, with a slightly different
> name.
> 
> arch/s390/Kconfig contains
> 
> config NO_IOMEM
>         def_bool y
> 
> and lib/Kconfig contains
> 
> config HAS_IOMEM
>         boolean
>         depends on !NO_IOMEM
>         default y

Now that is a good idea, I should be able to replace quite a few !S390
with HAS_IOMEM. It much better reflects WHY things don't work.
Just !S390 is so negative ..

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


