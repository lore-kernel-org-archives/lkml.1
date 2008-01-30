Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbYA3USk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbYA3USk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933091AbYA3UOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:14:15 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:55429 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbYA3UON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:14:13 -0500
Date: Wed, 30 Jan 2008 23:14:15 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080130201415.GA2473@jurassic.park.msu.ru>
References: <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128190505.5f5b1ccc@laptopd505.fenrus.org> <20080129031804.GF20198@parisc-linux.org> <20080129131955.GC10761@kroah.com> <20080130034555.GA17537@parisc-linux.org> <20080130151538.GA1036@jurassic.park.msu.ru> <20080130074249.36caa4c3@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130074249.36caa4c3@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 07:42:49AM -0800, Arjan van de Ven wrote:
> Xorg doesn't do pci express ..

Xorg core provides a set of PCI config access functions (via sysfs) for
the graphics drivers. These functions do work correctly with offsets > 256
bytes. Can you guarantee that none of PCI-E video drivers use that,
including proprietary nvidia and ati ones?

> (newer ones actually have gotten out of the "do the PCI layer ourselves" business entirely)

Unfortunately, not completely true. Though it has nothing to do with
extended config space.

Ivan.
