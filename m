Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYBIMlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYBIMlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYBIMlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:41:42 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42566 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYBIMll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:41:41 -0500
Date: Sat, 9 Feb 2008 05:41:39 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Tony Camuso <tcamuso@redhat.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Message-ID: <20080209124138.GA28967@parisc-linux.org>
References: <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128223141.GA31101@parisc-linux.org> <20080128225334.GD4720@kroah.com> <20080129025615.GC20198@parisc-linux.org> <20080129030340.GE20198@parisc-linux.org> <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com> <47AB299D.4000500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB299D.4000500@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 10:54:05AM -0500, Tony Camuso wrote:
> Matthew,
> 
> Perhaps I missed it, but did you address Yinghai's concerns?

No, I was on holiday.

> Yinghai Lu wrote:
> >On Jan 28, 2008 7:03 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> >>
> >>-int pci_conf1_write(unsigned int seg, unsigned int bus,
> >>+static int pci_conf1_write(unsigned int seg, unsigned int bus,
> >>                           unsigned int devfn, int reg, int len, u32 
> >>                           value)
> >
> >any reason to change pci_conf1_read/write to static?

Yes -- it no longer needs to be called from outside this file.

> >>+config ATA_RAM
> >>+       tristate "ATA RAM driver"
> >>+
> >
> >related?

No.  An unrelated patch that I didn't trim out.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
