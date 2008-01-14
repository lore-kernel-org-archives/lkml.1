Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYANQJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYANQJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYANQJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:09:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbYANQJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:09:10 -0500
Message-ID: <478B88FE.5020109@redhat.com>
Date: Mon, 14 Jan 2008 11:08:30 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>	<20080111213803.GS18741@parisc-linux.org>	<20080111235856.GA16079@jurassic.park.msu.ru>	<20080112002638.GA18710@kroah.com>	<20080112144030.GA19279@jurassic.park.msu.ru>	<20080112094557.71f5382a@laptopd505.fenrus.org>	<20080112214911.GA20102@jurassic.park.msu.ru>	<20080112150120.05f93768@laptopd505.fenrus.org>	<47895767.3090503@redhat.com>	<20080112164006.6f6f7bc2@laptopd505.fenrus.org>	<47896B3B.2000108@redhat.com>	<20080112204248.29abb1dd@laptopd505.fenrus.org>	<478A075F.7010503@redhat.com>	<20080113090311.0a9a1db5@laptopd505.fenrus.org>	<478A8268.6020107@redhat.com>	<20080114005434.48340f84@lxorguk.ukuu.org.uk>	<20080113173331.617ac935@laptopd505.fenrus.org>	<478AD713.8060204@redhat.com>	<20080113210501.4584e4d2@laptopd505.fenrus.o! rg>	<478B5D0D.7060808@redhat.com>	<20080114064614.22081ff3@laptopd505.fenrus.org>	<478B7E62.9070700@redhat.com> <20080114080150.23ace331@laptopd505.fenrus.org>
In-Reply-To: <20080114080150.23ace331@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> it's not pci_enable_mmconf(), it's pci_enable_extended_config_space... it's independent of the mechanism!
> 
Arjan, you would be foisting this call on device drivers running on
arches that don't need any such distinction between extended config
space and < 256 bytes.

I still think it's a bad policy.

Let's endeavor to confine arch-specific quirks to the arch-specific
code.

