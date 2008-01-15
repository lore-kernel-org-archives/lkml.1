Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYAORqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYAORqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYAORqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:46:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56912 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbYAORqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:46:33 -0500
Date: Tue, 15 Jan 2008 09:46:43 -0800
From: Greg KH <greg@kroah.com>
To: Loic Prylli <loic@myri.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>,
       Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080115174643.GB28238@kroah.com>
References: <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org> <20080114225225.GQ18741@parisc-linux.org> <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478CD8A5.5090608@myri.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 11:00:37AM -0500, Loic Prylli wrote:
>
>
> On 1/14/2008 6:04 PM, Adrian Bunk wrote:
>>> I thought so, but due to the way that things are initialised, mmconfig
>>> happens before conf1.  conf1 is known to be usable, but hasn't set
>>> raw_pci_ops at this point.  Confusing, and not ideal, but fixing this
>>> isn't in scope for 2.6.24.
>>> ...
>>>     
>>
>> *ahem*
>>
>> I don't think anything of what was discussed in this thread would be in 
>> scope for 2.6.24 (unless Linus wants to let the bunny that brings eggs 
>> release 2.6.24).
>>
>> cu
>> Adrian
>>   
>
>
> Why not put in 2.6.24 a simple fix for the last known remaining mmconfig 
> problems in 2.6.24?

Heh, no, because it is _way_ too late for such a patch that hasn't been
tested in any trees, sorry.

2.6.25 is the earliest I'll take such a fix, and if it's really as
simple as you say, I'll consider it for the -stable releases for .24 if
needed.

But so far, we have a zillion patches floating around, claiming
different things, some with signed-off-bys and others without, so for
now, I'll just stick with Arjan's patch in -mm and see if anyone
complains about those releases...

thanks,

greg k-h
