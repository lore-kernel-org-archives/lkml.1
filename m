Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab0BPRFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:05:07 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23822 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab0BPRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:05:04 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: build failure after merge final merge
Date: Tue, 16 Feb 2010 10:05:00 -0700
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20100216183650.e82c0f8e.sfr@canb.auug.org.au> <20100216083651.40ed48eb@jbarnes-piketon>
In-Reply-To: <20100216083651.40ed48eb@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002161005.00833.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 February 2010 09:36:51 am Jesse Barnes wrote:
> On Tue, 16 Feb 2010 18:36:50 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Jesse,
> > 
> > After merging, today's linux-next build (sparc64 defconfig) failed
> > like this:
> > 
> > arch/sparc/kernel/pci.c: In function 'pci_cfg_fake_ranges':
> > arch/sparc/kernel/pci.c:404: error: 'struct pci_bus' has no member

> Arg I thought we had fixed this one; maybe I applied an old patchset...
> Bjorn?

Nope, my patch doesn't touch that file, so I missed it (and a bunch
of others, it looks like).

Bjorn
