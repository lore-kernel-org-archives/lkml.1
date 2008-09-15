Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYIOXZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYIOXZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 19:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbYIOXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 19:25:25 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59137 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbYIOXZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 19:25:24 -0400
Date: Mon, 15 Sep 2008 19:25:22 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: tsbogend@alpha.franken.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
Message-ID: <20080915232522.GD15421@havoc.gtf.org>
References: <20080915215307.GA10340@alpha.franken.de> <20080915.151125.93659986.davem@davemloft.net> <20080915223807.GC15421@havoc.gtf.org> <20080915.154105.161656793.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915.154105.161656793.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 03:41:05PM -0700, David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Mon, 15 Sep 2008 18:38:07 -0400
> 
> > He continues to take non-regression fixes and minor cosmetic commits
> > from other trees.
> 
> I could complain about that, but he's pushed back hard enough
> on me that I don't consider that very fruitful.
> 
> Feel free if you want.

My impression was that Linus was in Wrath of God(tm) mode <grin> and he
was reacting strongly for effect not being specific.

But I would rather push my fixes, than complain about others' changes :)


> > Late -rc does not mean "no bug fixes at all except regressions" if you
> > look at the commits going into the kernel tree.
> 
> Actually, since you brought this up, he's allowing this largely in
> obscure subsystems and/or code he happens to be personally working on
> fixes for.

Well, obscure subsystems like PCI

      PCI: Fix printk warnings in setup-bus.c
      PCI: Fix printk warnings in probe.c

or libata

      sata_inic162x: enable LED blinking
      ata: duplicate variable sparse warning

or ia64 (this is not a regression, but a regular bug)

	ia64: fix panic during `modprobe -r xpc'

or bugs that have existed for a long time,

	bfs: fix Lockdep warning

As I understand and observe, Linus never ever wants to create
hard-and-fast rules, in this or anything, but set a general guideline
of not putting in changes (fixes or whatever) late in the game that
have a ghost of a chance of creating further problems.  That is the
underlying issue... don't create new headaches, _especially_ for large
userbases ;-)

So, I -totally- understand your reaction, but I think this is erring
too far on the side of caution.  Oh well...

	Jeff



