Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbXLWKfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbXLWKfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 05:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXLWKfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 05:35:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55074 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbXLWKfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 05:35:12 -0500
Date: Sun, 23 Dec 2007 02:33:48 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
 driver opt-in issue
Message-ID: <20071223023348.348608a8@laptopd505.fenrus.org>
In-Reply-To: <476DE98F.2010009@garzik.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	<476D1D16.5090703@garzik.org>
	<20071222064719.73fdd9a4@laptopd505.fenrus.org>
	<alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
	<476DB95F.3090801@garzik.org>
	<alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
	<476DDFEE.3010009@garzik.org>
	<alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
	<476DE98F.2010009@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 3) mmconfig might or might not be enabled, depending on which driver
> is loaded, whether it called an API or not.
> 
> 	Even LESS testing by hw vendors than #2.  Maybe even "never"
> 
> 	Inconsistent (config access depends on device)

the "depends on device" is even true for Linux today. For us today, MMCONFIG isn't always used, it's used on a per device basis already; except that the per-device is both defined by the bios and our quirks....
(the mmconfig code already falls back to conf1 cycles in various cases)

So I'm not entirely buying your argument. IN fact I'm not buying your "mixed is not tested at all" argument; while the statement may be true, it's not different than it is from Linux today... which is mixed. Just differently mixed I suppose.
