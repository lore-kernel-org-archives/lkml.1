Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbXLWKSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbXLWKSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 05:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbXLWKSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 05:18:07 -0500
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:40668 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752374AbXLWKSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 05:18:06 -0500
Date: Sun, 23 Dec 2007 11:18:02 +0100
From: Martin Mares <mj@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver opt-in issue
Message-ID: <mj+md-20071223.101546.31941.nikam@ucw.cz>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DE07A.4000204@garzik.org> <alpine.LFD.0.9999.0712222036010.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712222036010.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The fact is, 99% of the hardware you buy *today* has absolutely zero need 
> for extended PCI config access. In fact, I would not be surprised at all 
> if most hardware sold today generally doesn't have *any* devices that even 
> have config registers in the 0x100+ range.

Most PCI Express bridges have root complex control block capabilities
which have to reside in the extended range.

However I agree that hardware _requiring_ extended config register access
is rare.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
"Dijkstra probably hates me." -- /usr/src/linux/kernel/sched.c
