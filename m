Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbXEIUEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbXEIUEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXEIUEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:04:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46463 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbXEIUEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:04:13 -0400
Subject: Re: Section mismatch warnings (was Re: [PATCH] early_pfn_to_nid
	needs to be __meminit)
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Gabriel Paubert <paubert@iram.es>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <20070509194503.GZ4452@austin.ibm.com>
References: <20070510022552.4bb1a407.sfr@canb.auug.org.au>
	 <20070509165115.GA23576@iram.es>  <20070509194503.GZ4452@austin.ibm.com>
Content-Type: text/plain
Date: Wed, 09 May 2007 14:58:13 -0500
Message-Id: <1178740693.3086.81.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 14:45 -0500, Linas Vepstas wrote:
> On Wed, May 09, 2007 at 06:51:15PM +0200, Gabriel Paubert wrote:
> > On Thu, May 10, 2007 at 02:25:52AM +1000, Stephen Rothwell wrote:
> > > This removes a section mismatch warning in those circumstances.
> > 
> > Speaking of this, I just tried to compile an official (Linus' git tree) 
> > kernel for my old PMac G4 and I get a lot of section mismatch warnings at 
> > the end of the compilation:
> > 
> > WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to .init.text:early_get_page from .text between 'pte_alloc_one_kernel' (at offset 0xf50) and 'v_mapped_by_bats'
> > 
> > I find these 50 or so warnings so scary that I've not yet tried 
> > to boot the kernel. Note that this is a non-modular kernel.
> 
> I'm getting oodles of these on an older -mm2 tree. The kernels seem to
> work fine. Yes, they should be fixed but I'm up to my proverbial eyballs
> in alligators.

Yeah, I see all kinds of this too.  Does anyone have an idea why they're
being spit out?  Or if it's related to a particular binutils version,
etc?

josh

