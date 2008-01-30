Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYA3AIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYA3AIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYA3AIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:08:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbYA3AIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:08:30 -0500
Date: Wed, 30 Jan 2008 11:04:58 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Greg KH <greg@kroah.com>, Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: PCI x86: always use conf1 to access config space below 256
 bytes
In-Reply-To: <20080129234345.GB14088@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0801301102370.3344@www.l.google.com>
References: <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128223141.GA31101@parisc-linux.org> <20080128225334.GD4720@kroah.com>
 <20080129025615.GC20198@parisc-linux.org> <20080129025743.GD20198@parisc-linux.org> <20080129132108.GD10761@kroah.com> <20080129234345.GB14088@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jan 2008, Matthew Wilcox wrote:
> 
> Sorry, I didn't know that was the convention.  I thought the first
> Signed-off-by: was assumed to be the author.

There's certainly a strong correlation between "first sign-off" and 
authorship, but signing off doesn't guarantee it, and while it's not the 
bulk of patches, it certainly happens that people sign off on patches made 
by others (either because the company has specific people who have the 
right to sign off on things, or simply because the code comes from some 
source that did GPL it, but perhaps didn't sign off on it - hopefully 
rare, but certainly not impossible or unheard of especially for 
one-liners that got picked up from mailing lists etc)

		Linus
