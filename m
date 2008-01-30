Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbYA3PPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbYA3PPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYA3PPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:15:37 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:41872 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbYA3PPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:15:37 -0500
Date: Wed, 30 Jan 2008 18:15:39 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
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
Message-ID: <20080130151538.GA1036@jurassic.park.msu.ru>
References: <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128190505.5f5b1ccc@laptopd505.fenrus.org> <20080129031804.GF20198@parisc-linux.org> <20080129131955.GC10761@kroah.com> <20080130034555.GA17537@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130034555.GA17537@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 08:45:55PM -0700, Matthew Wilcox wrote:
> On Tue, Jan 29, 2008 at 05:19:55AM -0800, Greg KH wrote:
> > Matthew, with Arjan's patch, is anything that currently works now
> > broken?  Why do you feel it is somehow "wrong"?
> 
> lspci is broken.  It used to be able to access extended config space, and
> now can't unless it is patched to know about the sysfs flag to enable it.

There is also likely damage to Xorg for the very same reason.

Ivan.
