Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbXL0OM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbXL0OM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 09:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXL0OMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 09:12:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53344 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXL0OMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 09:12:19 -0500
Date: Thu, 27 Dec 2007 06:09:48 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Loic Prylli <loic@myri.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
 driver opt-in issue
Message-ID: <20071227060948.69a852a5@laptopd505.fenrus.org>
In-Reply-To: <4773908E.80600@garzik.org>
References: <476D1D16.5090703@garzik.org>
	<20071222064719.73fdd9a4@laptopd505.fenrus.org>
	<alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
	<476DB95F.3090801@garzik.org>
	<alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
	<476DDFEE.3010009@garzik.org>
	<alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
	<476DE98F.2010009@garzik.org>
	<476DF1A6.3060900@myri.com>
	<476DF5BE.5030004@garzik.org>
	<20071223110337.GA25441@jurassic.park.msu.ru>
	<alpine.LFD.0.9999.0712230925240.21557@woody.linux-foundation.org>
	<476F6047.50100@garzik.org>
	<alpine.LFD.0.9999.0712241036040.21557@woody.linux-foundation.org>
	<4773908E.80600@garzik.org>
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

On Thu, 27 Dec 2007 06:46:22 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Linus Torvalds wrote:
> > Well, the *current* behaviour as far as setup is concerned is 
> > unacceptable. But yes, longer term, we should be able to just have
> > quirk entries for saying "enable mmconfig because I know it's
> > safe", except we should not enable them until after the core PCI
> > probing has completed.
> 
> 
> IMO that should be an arch decision, buried somewhere in arch/x86.
> 
> If other arches implement extended config space sanely -- and
> possibly via some arch-specific means that is /not/ mmconfig -- then
> they should be able to make an arch decision that extended PCI config
> space accesses Just Work(tm).
> 
> For such arches, pci_enable_ext_cfg_space(pdev) would be a no-op,
> always returning success.
> 

both the first and the second patch already have this behavior.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
