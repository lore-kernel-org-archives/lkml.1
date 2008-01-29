Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbYA2X52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbYA2X52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYA2X5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:57:12 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:50516 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbYA2X5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:57:05 -0500
Date: Tue, 29 Jan 2008 16:57:03 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tcamuso@redhat.com, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080129235703.GC14088@parisc-linux.org>
References: <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128190505.5f5b1ccc@laptopd505.fenrus.org> <20080129031804.GF20198@parisc-linux.org> <20080129131955.GC10761@kroah.com> <479F34E6.40806@redhat.com> <20080129064724.0f7e91e5@laptopd505.fenrus.org> <479F4321.6030106@redhat.com> <20080129072951.5c8af9a0@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129072951.5c8af9a0@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 07:29:51AM -0800, Arjan van de Ven wrote:
> > Right now, that isn't a lot of people in x86 land, but your patch
> > encumbers drivers for non-x86 archs with an additional call to access
> > space that they've never had a problem with.
> 
> lets say s/x86/x86, IA64 and architectures that use intel, amd or via chipsets/

Umm .. ia64 already does exactly what I'm proposing for x86.  It uses
one SAL interface for bytes below 256 and a different SAL interface for
bytes 256-4095.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
