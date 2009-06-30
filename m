Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZF3QAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZF3QAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 12:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZF3QAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 12:00:41 -0400
Received: from outbound-mail-126.bluehost.com ([67.222.38.26]:60256 "HELO
	outbound-mail-126.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752474AbZF3QAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 12:00:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=klI2BIJYlESNI7QBTYEJJUHPWTsGzz1GqwmOmYgay84ViM9k4M2EvHhj2Dlu1UDXbLgtQflazKmzhx9QXdKYJTxDtNXQcy6wt0zS1mjLJ+TdZG4ExQ9gJsUREJnRI2GM;
Date: Tue, 30 Jun 2009 09:00:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alex Chiang <achiang@hp.com>
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
Message-ID: <20090630090038.6c490b7e@jbarnes-g45>
In-Reply-To: <20090630021612.GD24061@linux.intel.com>
References: <20090630115638.7bfb8e21.sfr@canb.auug.org.au>
	<20090629190135.7ff6a089@jbarnes-g45>
	<20090630021612.GD24061@linux.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 19:16:13 -0700
Matthew Wilcox <willy@linux.intel.com> wrote:

> On Mon, Jun 29, 2009 at 07:01:35PM -0700, Jesse Barnes wrote:
> > On Tue, 30 Jun 2009 11:56:38 +1000
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi Jesse,
> > > 
> > > Today's linux-next merge of the pci tree got conflicts in
> > > arch/ia64/include/asm/pci.h, arch/mn10300/include/asm/pci.h and
> > > include/asm-generic/pci.h between commit
> > > a6c140969b4685f9b9f6773c0760f55ca66d1825 ("Delete
> > > pcibios_select_root") from Linus' tree and commit
> > > a53cd7419b22c14b5a1e6859a940fb6bfa77963f ("PCI: remove
> > > pcibios_scan_all_fns()") from the pci tree.
> > > 
> > > Just context changes (adjacent removals).  I fixed it up (see
> > > below) and can carry the fix for a while.
> > 
> > Ah ok, thanks.  That'll get fixed up after I send the current
> > for-linus bits over and refresh my PCI tree.
> 
> I think you need to pull from Linus' tree before you send the bits
> over -- that's a conflict between Linus' tree and your tree, and you
> don't want to annoy Linus by making him merge them ;-)

Ah but I don't want to annoy Linus by merging either.  In fact, he's
stated explicitly several times that I should *not* pull his tree into
mine, either by rebasing or merging; his position is that pulling an
old tree from me should be fine, since no one else should have commits
in the PCI area, or if they do they'll be trivial and he'll fix them
up.

-- 
Jesse Barnes, Intel Open Source Technology Center
