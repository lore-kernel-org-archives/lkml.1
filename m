Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbXL1QRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbXL1QRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 11:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbXL1QRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 11:17:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35892 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbXL1QRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 11:17:33 -0500
Date: Fri, 28 Dec 2007 08:14:18 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Daniel Barkalow <barkalow@iabervon.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>, Loic Prylli <loic@myri.com>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20071228081418.08b60228@laptopd505.fenrus.org>
In-Reply-To: <20071228103451.GA28694@jurassic.park.msu.ru>
References: <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no>
	<4773EBB4.2020805@shaw.ca>
	<alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
	<477414C9.3040906@myri.com>
	<alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
	<alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org>
	<47742498.1060900@tragetaschen.dyndns.org>
	<alpine.LNX.1.00.0712272204520.13593@iabervon.org>
	<alpine.LFD.0.9999.0712272129290.21557@woody.linux-foundation.org>
	<alpine.LNX.1.00.0712280036330.13593@iabervon.org>
	<20071228103451.GA28694@jurassic.park.msu.ru>
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

On Fri, 28 Dec 2007 13:34:51 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On Fri, Dec 28, 2007 at 01:07:09AM -0500, Daniel Barkalow wrote:
> > So would always using conf1 for the non-extended space (unless the 
> > platform only uses mmconfig), or at least for the first 64 bytes.
> > I'd bet all the subtle bugs are in the first few words, anyway.
> > (With blatant bugs in the rest, of course, where we want to
> > blacklist busses and devices)
> 
> Yes. Though limiting conf1 to the first 64 bytes is simply not worth
> a pain - we would still have to deal with buses that are unreachable
> via mmconf.
> 
> Always using legacy configuration mechanism for the legacy config
> space and extended mechanism (mmconf) for the extended config space
> is a simple and very logical approach. It's supposed to resolve *all*
> known mmconf problems. And it still allows per-device quirks
> (tweaking dev->cfg_size). And it does *remove* code, not add anything
> new/untested.
> 

it removes code by removing quirks / known not working stuff..

I really don't like it.. sorry.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
