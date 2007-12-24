Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXLXHbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXLXHbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 02:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXLXHbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 02:31:25 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40054 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbXLXHbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 02:31:24 -0500
Message-ID: <476F6047.50100@garzik.org>
Date: Mon, 24 Dec 2007 02:31:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Loic Prylli <loic@myri.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org> <20071223110337.GA25441@jurassic.park.msu.ru> <alpine.LFD.0.9999.0712230925240.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712230925240.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> (For example: I have three machines that I know have working MMCONF. On 
> only one of theose does Linux actually even enable MMCONF accesses, 
> because on the two other ones the BIOSes do the crazy "put it in some 
> space that is reserved by PnP crap later", so we actually refuse to touch 
> it. So at least in my limited environment, we hardly get any MMCONFIG test 
> coverage, exactly because we have to be so totally anal about not enabling 
> it early, because we cannot guarantee that it's not clashing with anything 
> else).

Definitely.  So, two questions:


What's the preferred way to deal with the desire to view extended config 
space with "lspci -vvvxxx"?



Right now, we enable mmconfig for the bus/domain range requested by the 
BIOS [heh, so by implication many early BIOSen stomp themselves].

Is there a path for hw vendors, after passing 1,001 anal checks, to 
maintain the current behavior as it exists today in 
arch/x86/pci/mmconfig_{32,64}.c?

	Jeff


