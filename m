Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXLYJkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXLYJkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 04:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXLYJkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 04:40:36 -0500
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:60415 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751415AbXLYJkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 04:40:35 -0500
Date: Tue, 25 Dec 2007 10:40:34 +0100
From: Martin Mares <mj@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver opt-in issue
Message-ID: <mj+md-20071225.093812.26571.nikam@ucw.cz>
References: <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <20071223023348.348608a8@laptopd505.fenrus.org> <476F5A09.5010201@garzik.org> <20071224034935.600bdb30@laptopd505.fenrus.org> <476F9DF6.60100@garzik.org> <20071224040007.1277fddd@laptopd505.fenrus.org> <mj+md-20071225.091827.22368.nikam@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mj+md-20071225.091827.22368.nikam@ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reading past the first 256 bytes of the sysfs file should be enough
> -- only root can do that (other users get only 64 bytes anyway) and
> problems with reading random registers have hopefully taught programs
> not to read blindly a long time ago.

... except for lspci itself which reads the first few bytes of the
extended space to see if there are any capabilities, which is generally
safe, but it would always enable MMCONFIG.

So an extra switch will be really needed.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
The best way to accelerate Windows is at 9.8 m / sec^2
