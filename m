Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbXL1Qif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbXL1Qif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 11:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbXL1Qi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 11:38:27 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:42924 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbXL1Qi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 11:38:26 -0500
Date: Fri, 28 Dec 2007 19:38:41 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Daniel Barkalow <barkalow@iabervon.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>, Loic Prylli <loic@myri.com>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20071228163841.GA9409@jurassic.park.msu.ru>
References: <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org> <477414C9.3040906@myri.com> <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org> <47742498.1060900@tragetaschen.dyndns.org> <alpine.LNX.1.00.0712272204520.13593@iabervon.org> <alpine.LFD.0.9999.0712272129290.21557@woody.linux-foundation.org> <alpine.LNX.1.00.0712280036330.13593@iabervon.org> <20071228103451.GA28694@jurassic.park.msu.ru> <20071228081418.08b60228@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228081418.08b60228@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 08:14:18AM -0800, Arjan van de Ven wrote:
> it removes code by removing quirks / known not working stuff..

This not working stuff gets detected at probe time - see
drivers/pci/probe.c:pci_cfg_space_size().

Ivan.
