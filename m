Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbXLUI4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbXLUI4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 03:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXLUI4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 03:56:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbXLUI4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 03:56:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -mm 18/43] powerpc compat_binfmt_elf
In-Reply-To: Christoph Hellwig's message of  Friday, 21 December 2007 07:12:29 +0000 <20071221071229.GC4345@infradead.org>
References: <20071220115200.C767E26F98A@magilla.localdomain>
	<20071220115816.504CC26F98E@magilla.localdomain>
	<20071221071229.GC4345@infradead.org>
X-Zippy-Says: I hope I bought the right relish...  zzzzzzzzz...
Message-Id: <20071221085609.4D53B26F98A@magilla.localdomain>
Date: Fri, 21 Dec 2007 00:56:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Dec 20, 2007 at 03:58:16AM -0800, Roland McGrath wrote:
> > +obj-$(CONFIG_PPC64)		+= ../../../fs/compat_binfmt_elf.o
> 
> Building files from another directory is nasty.  Please add a
> CONFIG_BINFMT_COMPAT_ELF so we can simply build it in fs/

If that's better, please post the precise Kconfig magic you have in mind to
have it set when it should be.


Thanks,
Roland
