Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbXEITpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbXEITpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXEITpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:45:06 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56123 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbXEITpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:45:05 -0400
Date: Wed, 9 May 2007 14:45:03 -0500
To: Gabriel Paubert <paubert@iram.es>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch warnings (was Re: [PATCH] early_pfn_to_nid needs to be __meminit)
Message-ID: <20070509194503.GZ4452@austin.ibm.com>
References: <20070510022552.4bb1a407.sfr@canb.auug.org.au> <20070509165115.GA23576@iram.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509165115.GA23576@iram.es>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 06:51:15PM +0200, Gabriel Paubert wrote:
> On Thu, May 10, 2007 at 02:25:52AM +1000, Stephen Rothwell wrote:
> > This removes a section mismatch warning in those circumstances.
> 
> Speaking of this, I just tried to compile an official (Linus' git tree) 
> kernel for my old PMac G4 and I get a lot of section mismatch warnings at 
> the end of the compilation:
> 
> WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to .init.text:early_get_page from .text between 'pte_alloc_one_kernel' (at offset 0xf50) and 'v_mapped_by_bats'
> 
> I find these 50 or so warnings so scary that I've not yet tried 
> to boot the kernel. Note that this is a non-modular kernel.

I'm getting oodles of these on an older -mm2 tree. The kernels seem to
work fine. Yes, they should be fixed but I'm up to my proverbial eyballs
in alligators.

--linas
