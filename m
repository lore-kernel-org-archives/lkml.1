Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbXLWVP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbXLWVP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 16:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXLWVPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 16:15:16 -0500
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:57327 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751797AbXLWVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 16:15:15 -0500
Date: Sun, 23 Dec 2007 22:15:10 +0100
From: Martin Mares <mj@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver opt-in issue
Message-ID: <mj+md-20071223.211353.32429.nikam@ucw.cz>
References: <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <alpine.LFD.0.9999.0712222058160.21557@woody.linux-foundation.org> <1198444150.6686.17.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198444150.6686.17.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

>  - During that probe, you set a flag if any device has capabilities that
> extend beyond 0xff.

Can this work?  The extended capabilities are not linked to the normal
ones in any way.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
A bug in the code is worth two in the documentation.
