Return-Path: <linux-kernel-owner+w=401wt.eu-S1751839AbYANFXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbYANFXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 00:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYANFXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 00:23:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbYANFXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 00:23:07 -0500
Date: Sun, 13 Jan 2008 21:20:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: tcamuso@redhat.com, Arjan van de Ven <arjan@infradead.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <20080114005434.48340f84@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.00.0801132119520.2806@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
 <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <20080112094557.71f5382a@laptopd505.fenrus.org> <20080112214911.GA20102@jurassic.park.msu.ru>
 <20080112150120.05f93768@laptopd505.fenrus.org> <47895767.3090503@redhat.com> <20080112164006.6f6f7bc2@laptopd505.fenrus.org> <47896B3B.2000108@redhat.com> <20080112204248.29abb1dd@laptopd505.fenrus.org> <478A075F.7010503@redhat.com>
 <20080113090311.0a9a1db5@laptopd505.fenrus.org> <478A8268.6020107@redhat.com> <20080114005434.48340f84@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jan 2008, Alan Cox wrote:
> > 
> > As someone gently pointed out to me, you are in a position to know this,
> > so I probably am wrong.
> 
> I suspect Arjan is wrong. It might be some Intel agenda but I still see
> fairly new driver reference code that is hardcoding port accesses even
> when designed for Redmond products.

Agreed. I suspect that the likelihood of conf1 accesses going away in the 
next five years is slim to none.

			Linus
