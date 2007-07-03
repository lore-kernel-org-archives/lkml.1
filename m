Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbXGCVgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbXGCVgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbXGCVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:36:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:47878 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbXGCVgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:36:08 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
In-Reply-To: <200707032259.59714.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031709.29968.rjw@sisk.pl> <200707031920.59940.oliver@neukum.org>
	 <200707032259.59714.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 07:35:18 +1000
Message-Id: <1183498518.3388.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't think that would matter.
> 
> Still, I can remove the sync from the suspend code path only, leaving it in
> the hibernation code path.  The patch will be bigger, but well.
> 
> Any objection to that?

Makes sense to sync before suspend tho, to limit the amount of dirty
non-written pages in case things go wrong.

Ben.


