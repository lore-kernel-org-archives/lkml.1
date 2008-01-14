Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYANA7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYANA7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 19:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbYANA7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 19:59:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53384 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755144AbYANA7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 19:59:01 -0500
Date: Mon, 14 Jan 2008 00:54:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tcamuso@redhat.com
Cc: Arjan van de Ven <arjan@infradead.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080114005434.48340f84@lxorguk.ukuu.org.uk>
In-Reply-To: <478A8268.6020107@redhat.com>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<20080111204228.GP18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
	<20080112094557.71f5382a@laptopd505.fenrus.org>
	<20080112214911.GA20102@jurassic.park.msu.ru>
	<20080112150120.05f93768@laptopd505.fenrus.org>
	<47895767.3090503@redhat.com>
	<20080112164006.6f6f7bc2@laptopd505.fenrus.org>
	<47896B3B.2000108@redhat.com>
	<20080112204248.29abb1dd@laptopd505.fenrus.org>
	<478A075F.7010503@redhat.com>
	<20080113090311.0a9a1db5@laptopd505.fenrus.org>
	<478A8268.6020107@redhat.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 16:28:08 -0500
Tony Camuso <tcamuso@redhat.com> wrote:

> Arjan van de Ven wrote:
> 
> >> The PCI spec provides for conf1 as an architected solution. It's not
> >> going away, and especially not in x86 land where Port IO is built-in
> >> to the CPU.
> > 
> > again sadly you're wrong. 
> > 
> 
> As someone gently pointed out to me, you are in a position to know this,
> so I probably am wrong.

I suspect Arjan is wrong. It might be some Intel agenda but I still see
fairly new driver reference code that is hardcoding port accesses even
when designed for Redmond products.

Alan
