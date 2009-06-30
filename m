Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbZF3CQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbZF3CQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZF3CQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:16:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:3168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZF3CQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:16:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,313,1243839600"; 
   d="scan'208";a="528913418"
Date: Mon, 29 Jun 2009 19:16:13 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alex Chiang <achiang@hp.com>
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
Message-ID: <20090630021612.GD24061@linux.intel.com>
References: <20090630115638.7bfb8e21.sfr@canb.auug.org.au> <20090629190135.7ff6a089@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629190135.7ff6a089@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 07:01:35PM -0700, Jesse Barnes wrote:
> On Tue, 30 Jun 2009 11:56:38 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Jesse,
> > 
> > Today's linux-next merge of the pci tree got conflicts in
> > arch/ia64/include/asm/pci.h, arch/mn10300/include/asm/pci.h and
> > include/asm-generic/pci.h between commit
> > a6c140969b4685f9b9f6773c0760f55ca66d1825 ("Delete
> > pcibios_select_root") from Linus' tree and commit
> > a53cd7419b22c14b5a1e6859a940fb6bfa77963f ("PCI: remove
> > pcibios_scan_all_fns()") from the pci tree.
> > 
> > Just context changes (adjacent removals).  I fixed it up (see below)
> > and can carry the fix for a while.
> 
> Ah ok, thanks.  That'll get fixed up after I send the current for-linus
> bits over and refresh my PCI tree.

I think you need to pull from Linus' tree before you send the bits over
-- that's a conflict between Linus' tree and your tree, and you don't
want to annoy Linus by making him merge them ;-)
