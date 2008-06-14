Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYFNU23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYFNU23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 16:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYFNU2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 16:28:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50120 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbYFNU2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 16:28:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] PCI fixes
Date: Sat, 14 Jun 2008 22:29:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <200806141323.45935.jbarnes@virtuousgeek.org>
In-Reply-To: <200806141323.45935.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806142229.20177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 of June 2008, Jesse Barnes wrote:
> Please pull the final (I hope!) fixes for 2.6.26:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus
> 
> It's mainly a set of fixes I got from Ingo which have been soaking for
> awhile, including the resourceN_wc API, which should have been pushed
> upstream before now, but which has seen a lot of exposure in Ingo's
> tree.  Shortlog, diffstat & diff below.
> 
> Note that to take advantage of the new resourceN_wc file in X you'll need
> something like the patch I just posted to xorg@lists.freedesktop.org.
> 
> Also, since I pulled the changes from Ingo, there are two duplicates (Bertram
> & Tony's patches) and a merge commit; hopefully they won't cause trouble.
> 
> Thanks,
> Jesse
> 
> Bertram Felgenhauer (1):
>       pci, x86: add workaround for bug in ASUS A7V600 BIOS (rev 1005)
> 
> Jesse Barnes (2):
>       Merge branch 'pci-for-jesse' of git://git.kernel.org/.../x86/linux-2.6-tip into for-linus
>       PCI: fixup write combine comment in pci_mmap_resource
> 
> Miquel van Smoorenburg (2):
>       x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
>       x86, pci-dma.c: don't always add __GFP_NORETRY to gfp
> 
> Pavel Machek (1):
>       suspend-vs-iommu: prevent suspend if we could not resume

This has been merged already AFAICS, commit
cd76374e9de4501acc74f833dc6cb5e7a5dca115 .

Thanks,
Rafael
