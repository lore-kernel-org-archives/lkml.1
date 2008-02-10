Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYBJU21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYBJU21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYBJU2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:28:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56639 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbYBJU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:28:18 -0500
Date: Sun, 10 Feb 2008 12:24:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
In-Reply-To: <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org>
References: <20080128204431.GA15227@kroah.com>  <20080128225334.GD4720@kroah.com>  <20080129025615.GC20198@parisc-linux.org>  <20080129030340.GE20198@parisc-linux.org>  <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com>  <47AB299D.4000500@redhat.com>
  <20080209124138.GA28967@parisc-linux.org>  <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>  <20080210072116.GA12375@kroah.com>  <20080210145122.GC5299@parisc-linux.org> <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Feb 2008, Yinghai Lu wrote:
> >
> > I suggest Ivan's patch be merged ASAP as it actually fixes bugs.
> > This patch is just cleanup (and takes care of some future concerns).
> 
> your patch and Ivan's patch should be merged in one...

I really don't care whether they get merges as one or separately, but I 
think it should be merged _now_ (-rc1 is already delayed), and I'd like to 
see the final versions of both. Does anybody have them in a final 
agreed-upon format (preferably with that oddness in quirk_intel_irqbalance 
also fixed?)

		Linus
