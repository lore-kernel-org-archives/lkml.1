Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbYA2Q1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbYA2Q1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYA2Q1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:27:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbYA2Q1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:27:24 -0500
Message-ID: <479F53B1.9000101@redhat.com>
Date: Tue, 29 Jan 2008 11:26:25 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <20080114225225.GQ18741@parisc-linux.org>	<20080114230448.GL9847@does.not.exist>	<478CD8A5.5090608@myri.com>	<20080115174643.GB28238@kroah.com>	<20080115175641.GE18741@parisc-linux.org>	<20080119165809.GB11553@colo.lackof.org>	<479E1FA6.1030708@redhat.com>	<20080128204431.GA15227@kroah.com>	<20080128190505.5f5b1ccc@laptopd505.fenrus.org>	<20080129031804.GF20198@parisc-linux.org>	<20080129131955.GC10761@kroah.com>	<479F34E6.40806@redhat.com>	<20080129064724.0f7e91e5@laptopd505.fenrus.org>	<479F4321.6030106@redhat.com> <20080129072951.5c8af9a0@laptopd505.fenrus.org>
In-Reply-To: <20080129072951.5c8af9a0@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 29 Jan 2008 10:15:45 -0500
> Tony Camuso <tcamuso@redhat.com> wrote:
> 

>> specific to legacy x86 hardware is, IMNSHO, a kludge.
> 
> in addition to pci_enable(), pci_enable_msi(), pci_enable_busmaster() they already need to do
> to enable various features?
> 

These calls are related to generic aspects of the PCI* landscape itself and are
not related to any arch-specific hardware, nor were they devised to address
chipset-specific or BIOS-specific problems.

For the good of all, we should endeavor to avoid putting arch-specific fixes into
the generic code whenever possible.

And in this case, not only is it possible, it's been done and tested.

