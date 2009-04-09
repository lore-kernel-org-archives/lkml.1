Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbZDIVHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbZDIVHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbZDIVHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:07:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbZDIVHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:07:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091042240.4583@localhost.localdomain> <20090409163255.22778.39921.stgit@warthog.procyon.org.uk> <20090409163300.22778.92061.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
Date: Thu, 09 Apr 2009 22:05:56 +0100
Message-ID: <11730.1239311156@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Please use "-M" when creating diffs for sending to me, so that the diffs 
> are rename diffs, and so that you can _see_ that they are renames. No, 
> it's not the git default, but that's because there are still too many crap 
> SCM's out there, and too many people using "patch".

I should've used:

	stg mail -diff-opts=-M

it would appear.  I wonder if this should be the default.

Note that

	git-diff -M HEAD^ HEAD

does not make output that looks like yours.  It's missing the:

	 {include/asm-frv => arch/frv/include/asm}/Kbuild   |    0
	 {include/asm-frv => arch/frv/include/asm}/atomic.h |    0
	 {include/asm-frv => arch/frv/include/asm}/auxvec.h |    0
	 .../asm-frv => arch/frv/include/asm}/ax88796.h     |    0
	 {include/asm-frv => arch/frv/include/asm}/bitops.h |    0
	 {include/asm-frv => arch/frv/include/asm}/bug.h    |    0
	 {include/asm-frv => arch/frv/include/asm}/bugs.h   |    0
	 .../asm-frv => arch/frv/include/asm}/busctl-regs.h |    0
	 .../asm-frv => arch/frv/include/asm}/byteorder.h   |    0
	 {include/asm-frv => arch/frv/include/asm}/cache.h  |    0
	...
	114 files changed, 0 insertions(+), 0 deletions(-)

bits.  Though it does have:

	diff --git a/include/asm-frv/Kbuild b/arch/frv/include/asm/Kbuild
	similarity index 100%
	rename from include/asm-frv/Kbuild
	rename to arch/frv/include/asm/Kbuild

and onwards.

How did you get the first bit?

David
