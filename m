Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYKULIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYKULIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYKULIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:08:37 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:53134 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYKULIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:08:36 -0500
Date: Fri, 21 Nov 2008 04:08:19 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, greg@kroah.com,
       linux-pci@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       kkeil@suse.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_PCI_LEGACY removal
Message-ID: <20081121110819.GA5707@parisc-linux.org>
References: <20081121181426.9f5efa36.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121181426.9f5efa36.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 06:14:26PM +1100, Stephen Rothwell wrote:
> Users of pci_find_device():
> 
> drivers/isdn/hisax/avm_pci.c
> drivers/isdn/hisax/bkm_a4t.c
> drivers/isdn/hisax/bkm_a8.c
> drivers/isdn/hisax/diva.c
> drivers/isdn/hisax/elsa.c
> drivers/isdn/hisax/enternow_pci.c
> drivers/isdn/hisax/gazel.c
> drivers/isdn/hisax/hfc_pci.c
> drivers/isdn/hisax/niccy.c
> drivers/isdn/hisax/nj_s.c
> drivers/isdn/hisax/nj_u.c
> drivers/isdn/hisax/sedlbauer.c
> drivers/isdn/hisax/telespci.c
> drivers/isdn/hisax/w6692.c

I think the plan is to delete all these drivers once the new ISDN layer
is a bit more battle-hardened.

> User of pci_find_slot():
> 
> drivers/pci/hotplug/cpqphp_pci.c

The cpqphp driver is basically unmaintained.  Last time I spoke to Greg
about it (which was probably three years ago) he said it wasn't possible
to find a machine which had one of these any more.

I suspect the driver should simply be deleted, but if anyone steps up
and claims to have one of these to test the resulting patch, I'm willing
to remove pci_find_slot() from it.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
