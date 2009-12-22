Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZLVNRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZLVNRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZLVNRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:17:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbZLVNRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:17:35 -0500
Date: Tue, 22 Dec 2009 14:17:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: peterhuewe@gmx.de, kernel-janitors@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add __init/__exit macros to
 drivers/misc/hwlat_detector.c
In-Reply-To: <20091222130246.GA2368@pengutronix.de>
Message-ID: <alpine.LNX.2.00.0912221416230.3755@pobox.suse.cz>
References: <1261470564-23754-1-git-send-email-peterhuewe@gmx.de> <20091222130246.GA2368@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Uwe Kleine-König wrote:

> > Trivial patch which adds the __init/__exit macros to the module_init/
> > module_exit functions of
> > 
> > drivers/misc/hwlat_detector.c
> > 
> > Please have a look at the small patch and either pull it through
> > your tree, or please ack' it so Jiri can pull it through the trivial
> > tree.
> > 
> > Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
> > but also present in linus tree.
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> The commit log contains some things that are maybe interesting in this
> mail, but not in git (base tree, plea to look, exact filename).
> 
> Apart from Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

The changelog claims that this is against current Linus' tree and patches 
drivers/misc/hwlat_detector.c file, but I can't seem to see anything 
similar in current Linus' tree (HEAD on f7b84a6ba7e).

	$ find . -name hwlat_detector.c
	$

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
