Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXEaVUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXEaVUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXEaVUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:20:01 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbXEaVUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:20:01 -0400
Date: Thu, 31 May 2007 14:19:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
       Arnd Bergmann <arndb@de.ibm.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.22-rc3-mm1
Message-Id: <20070531141943.5c4d587c.akpm@linux-foundation.org>
In-Reply-To: <200705312243.18724.m.kozlowski@tuxland.pl>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<200705312243.18724.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 22:43:18 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello
> 
> 	This is from iMac G3. The spufs_mem_mmap_fault() code looks bad
> in arch/powerpc/platforms/cell/spufs/file.c but somehow I'm unable to find
> the patch to blame hmm.
> 
> arch/powerpc/platforms/cell/spufs/file.c: In function 'spufs_mem_mmap_fault':
> arch/powerpc/platforms/cell/spufs/file.c:122: error: 'address' undeclared (first use in this function)
> arch/powerpc/platforms/cell/spufs/file.c:122: error: (Each undeclared identifier is reported only once
> arch/powerpc/platforms/cell/spufs/file.c:122: error: for each function it appears in.)
> arch/powerpc/platforms/cell/spufs/file.c:141: error: expected ';' before 'if'
> arch/powerpc/platforms/cell/spufs/file.c:122: warning: unused variable 'addr0'
> make[3]: *** [arch/powerpc/platforms/cell/spufs/file.o] Blad 1
> make[2]: *** [arch/powerpc/platforms/cell/spufs] Blad 2
> make[1]: *** [arch/powerpc/platforms/cell] Blad 2
> 

Yeah, that's the fix-fault-vs-invalidate-race patches, or my poor attempt
to fix them when spufs changed.  I suppose I'll have a poke at it next time
I get the powerpc machine fired up.
