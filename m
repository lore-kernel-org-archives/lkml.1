Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZBYFq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZBYFq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 00:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZBYFqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 00:46:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZBYFqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 00:46:49 -0500
Date: Wed, 25 Feb 2009 00:46:44 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kyle McMartin <kyle@infradead.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kyle@redhat.com, roland@redhat.com,
       aoliva@redhat.com
Subject: Re: [PATCH/RFC] powerpc: avoid generating .eh_frame sections with
	gcc-4.4
Message-ID: <20090225054644.GF6690@bombadil.infradead.org>
References: <20090224065112.GA6690@bombadil.infradead.org> <20090225054707.GA20364@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225054707.GA20364@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 06:47:07AM +0100, Sam Ravnborg wrote:
> > On ppc64 (at least) gcc-4.4 is defaulting to generating .eh_frame
> > sections, which are, for the kernel, fairly pointless. Additionally, on
> > ppc64 this generates a relocation format which the kernel module loader
> > does not currently support (R_PPC64_REL32.)
> > 
> > Alexandre Oliva verifies that -fno-dwarf2-cfi-asm prevents this
> > .eh_frame section from being generated.
> > 
> > These seem to be used for unwinding, but it doesn't look like we
> > currently use them anywhere. (In fact, we explicitly dump them in the
> > x86_64 linker script.)
> > 
> > If these .eh_frame sections are eventually used, adding a per-arch
> > CONFIG_WANT_UNWIND check would be trivial.
> > 
> > (This was reported against Fedora, which appears to be the only distro
> > doing any building against gcc-4.4 at present: RH bz#486545.)
> > 
> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
> > Cc: roland@redhat.com
> > Cc: aoliva@redhat.com
> 
> Kyle - can you resend wit an updated changelog reflecting the comments
> from Roland and Alexandre.
> 
> I got it wrong when reading the above - so chances are others does too.
> 

Yes, certainly. My apologies, I let my frustration leak through a little
into the changelog. :)

regards, Kyle
