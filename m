Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbXLVUhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbXLVUhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXLVUg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:36:57 -0500
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:38863 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753233AbXLVUg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:36:57 -0500
Date: Sat, 22 Dec 2007 21:36:55 +0100
From: Martin Mares <mj@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver opt-in issue
Message-ID: <mj+md-20071222.203331.9078.nikam@ucw.cz>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <mj+md-20071222.192526.25019.nikam@ucw.cz> <20071222121503.3502382a@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222121503.3502382a@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> it's not "just a couple of chipsets", it's actually
> * a whole lot of bioses
> * at least one whole CPU generation
> * ..
> * ..
> 
> Do you really want to code all of that into your userspace access code as well?

No, I certainly don't. But I expect this to be handled reasonably in the
kernel.

If I understand the proposed patch correctly, it's only swepping the problem
under the carpet -- if you have one of the malfunctioning systems and
you happen to load a driver which wants to use the extended config
space, it crashes anyway.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
It said, "Insert disk #3," but only two will fit!
