Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZEOAHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZEOAHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 20:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZEOAHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 20:07:25 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18231 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZEOAHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 20:07:25 -0400
Date: Thu, 14 May 2009 18:07:25 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/10] x86/PCI: Enable scanning of all pci functions
Message-ID: <20090515000725.GA27084@ldl.fc.hp.com>
References: <1242164891-3859-1-git-send-email-jeremy@goop.org> <1242164891-3859-7-git-send-email-jeremy@goop.org> <20090513095535.140134e1@jbarnes-g45> <4A0AFE84.2040805@goop.org> <20090513102316.5ef3ce4e@jbarnes-g45> <4A0C66DB.9020707@goop.org> <20090514121513.198ada4e@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514121513.198ada4e@jbarnes-g45>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Thu, 14 May 2009 11:45:47 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Jesse Barnes wrote:
> > > Anyway it's not a big deal, this code is already ugly (a 0 define
> > > for all arches?  why?) so you shouldn't have to spend too much time
> > > cleaning it up.
> > >   
> > 
> > OK, how's this as a delta (I can fold it into the previous patch if 
> > you're OK with it):
> > 
> > Subject: [PATCH] pci: add HAVE_ARCH_PCIBIOS_SCAN_ALL_FNS
> > 
> > Jesse objected to the "#undef pcibios_scan_all_fns"'s ugliness,
> > so replace it with the more common HAVE_ARCH_ idiom.
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> That's slightly better.  It looks like we should just get rid of
> pcibios_scan_all_fns altogether, but this is fine for now.

It's been on my TODO list for a while now, but then holiday and
now surgery got in the way.

/ac

