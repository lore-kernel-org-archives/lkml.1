Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZFWQp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZFWQp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZFWQpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:45:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49328 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbZFWQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:45:14 -0400
Date: Tue, 23 Jun 2009 12:45:05 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2] fbdev: work around old compiler bug
Message-ID: <20090623164505.GA3101@bombadil.infradead.org>
References: <20090622180420.2e0424e4.sfr@canb.auug.org.au> <20090622183415.46fa786b.sfr@canb.auug.org.au> <20090623154428.e2f4ddc9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623154428.e2f4ddc9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 03:44:28PM +1000, Stephen Rothwell wrote:
> When building with a 4.1.x compiler on powerpc64 (at least) we get
> this error:
> 
> drivers/video/logo/logo_linux_mono.c:81: error: logo_linux_mono causes a section type conflict
> 
> This was introduced by commit ae52bb2384f721562f15f719de1acb8e934733cb
> ("fbdev: move logo externs to header file").  This is a partial revert
> of that commit sufficient to not hit the compiler bug.
> 

We're seeing similar issues with 4.3 on parisc (the case I saw today was
in fs/nfs/nfsroot.c...) Any ideas on the actual culprit or is it just
gcc being unfriendly?

regards, Kyle
