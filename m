Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbXLXLyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbXLXLyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 06:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXLXLyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 06:54:39 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60056 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbXLXLyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 06:54:38 -0500
Message-ID: <476F9DF6.60100@garzik.org>
Date: Mon, 24 Dec 2007 06:54:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org>	<476D1D16.5090703@garzik.org>	<20071222064719.73fdd9a4@laptopd505.fenrus.org>	<alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>	<476DB95F.3090801@garzik.org>	<alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>	<476DDFEE.3010009@garzik.org>	<alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>	<476DE98F.2010009@garzik.org>	<20071223023348.348608a8@laptopd505.fenrus.org>	<476F5A09.5010201@garzik.org> <20071224034935.600bdb30@laptopd505.fenrus.org>
In-Reply-To: <20071224034935.600bdb30@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> I can see the point of having a sysfs attribute to enable MMCONF from userspace, so
> that userland diagnostics tools can turn it on if they really really want to.
> (I'd make that printk a nice warning "application XYZ is enabling extended config space for devize ABC" so
> that if the box then crashes and burns, people know who/why and where to direct their emails ;-)
> 
> We did something similar for "enable", it's maybe 10 lines of code or so.
> 
> I would assume lspci and friends would then only turn that on at explicit admin request

Absolutely...  I'm not asking to default it on, just asking for it to be 
possible :)

	Jeff


