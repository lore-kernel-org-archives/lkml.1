Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbYHEM1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbYHEM1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759895AbYHEM1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:27:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47813 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760315AbYHEM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:27:38 -0400
Date: Tue, 5 Aug 2008 06:26:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Simon Horman <horms@verge.net.au>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch] PCI: check the return value of device_create_bin_file() in pci_create_bus()
Message-ID: <20080805122639.GP26461@parisc-linux.org>
References: <20080805101605.GA19382@verge.net.au> <1217932416.7758.4.camel@localhost> <20080805101605.GA19382@verge.net.au> <alpine.LNX.1.10.0808051224350.5671@titan.stealer.net> <20080805110006.GA13409@verge.net.au> <20080805111406.GA13899@verge.net.au> <20080805112814.GO26461@parisc-linux.org> <20080805121531.GA29763@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805121531.GA29763@verge.net.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 10:15:32PM +1000, Simon Horman wrote:
> On Tue, Aug 05, 2008 at 05:28:14AM -0600, Matthew Wilcox wrote:
> > Yes, but you're essentially saying here that if I can't create a couple
> > of poxy sysfs files, I can't have this PCI bus at all?  This seems like
> > a bad decision to me.  I'd rather have a PCI bus without the files than
> > no PCI bus at all.  By all means, we should whinge mightily if we can't
> > create the files so the sysadmin has a chance of figuring out why things
> > aren't quite working right, but I might have my root filesystem on a
> > device on that PCI bus.
> 
> Are you suggesting just making pci_create_bus() have a big winge
> using printk() but returning void regardless of what happens?
> That sounds fine to me, though I guess it would also need to unwind
> if the first call to device_create_bin_file() succeeds but the second
> one doesn't.

Sounds like the right course of action to me.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
