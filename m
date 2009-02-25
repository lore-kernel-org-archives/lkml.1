Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZBYFp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZBYFp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 00:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZBYFpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 00:45:15 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58090 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZBYFpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 00:45:14 -0500
Date: Wed, 25 Feb 2009 06:47:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, kyle@redhat.com,
       roland@redhat.com, aoliva@redhat.com
Subject: Re: [PATCH/RFC] powerpc: avoid generating .eh_frame sections with gcc-4.4
Message-ID: <20090225054707.GA20364@uranus.ravnborg.org>
References: <20090224065112.GA6690@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224065112.GA6690@bombadil.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 01:51:12AM -0500, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> On ppc64 (at least) gcc-4.4 is defaulting to generating .eh_frame
> sections, which are, for the kernel, fairly pointless. Additionally, on
> ppc64 this generates a relocation format which the kernel module loader
> does not currently support (R_PPC64_REL32.)
> 
> Alexandre Oliva verifies that -fno-dwarf2-cfi-asm prevents this
> .eh_frame section from being generated.
> 
> These seem to be used for unwinding, but it doesn't look like we
> currently use them anywhere. (In fact, we explicitly dump them in the
> x86_64 linker script.)
> 
> If these .eh_frame sections are eventually used, adding a per-arch
> CONFIG_WANT_UNWIND check would be trivial.
> 
> (This was reported against Fedora, which appears to be the only distro
> doing any building against gcc-4.4 at present: RH bz#486545.)
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> Cc: roland@redhat.com
> Cc: aoliva@redhat.com

Kyle - can you resend wit an updated changelog reflecting the comments
from Roland and Alexandre.

I got it wrong when reading the above - so chances are others does too.

Thanks,
	Sam
