Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYALPrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYALPrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 10:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYALPrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 10:47:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40595 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYALPq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:46:59 -0500
Date: Sat, 12 Jan 2008 07:46:32 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>,
       Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080112074632.3ca72d27@laptopd505.fenrus.org>
In-Reply-To: <20080112144030.GA19279@jurassic.park.msu.ru>
References: <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>
	<20080111201716.GO18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<20080111204228.GP18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
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

On Sat, 12 Jan 2008 17:40:30 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
e.
> 
> > Ivan, you posted one a while ago, but never seemed to get any
> > confirmation if it helped or not.  Should I use that and drop
> > Arjan's?
> 
> Actually I'm strongly against Arjan's patch. First, it's based on
> assumption that the MMCONFIG thing is sort of fundamentally broken
> on some systems, but none of the facts we have so far does confirm
> that. And second, I really don't like the implementation as it breaks
> all non-x86 arches (or forces them to add a set of totally meaningless
> PCI functions).

no it doesn't!
Other arches need no changes.
