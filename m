Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbXLLN2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbXLLN2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 08:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXLLN2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 08:28:42 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54591 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752040AbXLLN2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 08:28:41 -0500
Date: Wed, 12 Dec 2007 14:28:42 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/47] CRIS patches for CRISv32 EtraxFS and ARTPEC-3
Message-ID: <20071212132842.GA10069@stusta.de>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com> <20071212025212.51eed892.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071212025212.51eed892.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 02:52:12AM -0800, Andrew Morton wrote:
> On Thu, 29 Nov 2007 17:02:22 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> 
> > Hi,
> > 
> > This patchset contains the differences to add support for the EtraxFS and
> > ARTPEC-3 CPUs, both of the CRISv32 family.  Both chips can now be compiled
> > with minimal configs.
> > 
> > To compile you'll need the Axis gcc cross port for CRISv32, it is mentioned
> > in http://marc.info/?l=linux-kernel&m=119337976126184&w=2 how to get this.
> > 
> > Still missing to allow full compile is include/linux/mtd/mtdram.h,
> > see http://marc.info/?l=linux-kernel&m=119373777301863&w=2
> > 
> > This is step two in syncing the Axis internal changes with mainline Linux,
> > with the final goal being getting the CRIS port to the same level as
> > the rest of the kernel.
> > 
> > I've tried to remove as much checkpatch warnings and errors as possible,
> > but some remain, mostly (I think you'll agree) spurious warnings,
> > although there's also a bunch of generated files which don't conform,
> > but I hope to fix this at the source later on.
> > 
> > I realise this is a hefty chunk of code to review, but any suggestions
> > on improvements are thankfully received.
> > 
> > The changes are also available in the export2 branch at
> > 
> > git://www.jni.nu/axis.git
> 
> I don't think there's much point in me merging these.  Please ask Linus to
> pull that tree once the 2.6.25 merge window opens.

This sounds reasonable for the arch/cris/ and include/asm-cris/ parts, 
but shouldn't the rest go through the maintainers?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

