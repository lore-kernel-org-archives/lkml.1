Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYALQX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYALQX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 11:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYALQXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 11:23:19 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:35574 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYALQXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 11:23:14 -0500
Date: Sat, 12 Jan 2008 19:23:36 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>,
       Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080112162336.GA19986@jurassic.park.msu.ru>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <20080112074632.3ca72d27@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112074632.3ca72d27@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 07:46:32AM -0800, Arjan van de Ven wrote:
> Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
> > Actually I'm strongly against Arjan's patch. First, it's based on
> > assumption that the MMCONFIG thing is sort of fundamentally broken
> > on some systems, but none of the facts we have so far does confirm
> > that. And second, I really don't like the implementation as it breaks
> > all non-x86 arches (or forces them to add a set of totally meaningless
> > PCI functions).
> 
> no it doesn't!
> Other arches need no changes.

Umm, true. I misread your patch.
But it doesn't change anything - that wasn't my main objection
anyway.

Ivan.
