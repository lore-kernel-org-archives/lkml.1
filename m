Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbXLUHMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbXLUHMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXLUHMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:12:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42372 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbXLUHMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:12:40 -0500
Date: Fri, 21 Dec 2007 07:12:29 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -mm 18/43] powerpc compat_binfmt_elf
Message-ID: <20071221071229.GC4345@infradead.org>
References: <20071220115200.C767E26F98A@magilla.localdomain> <20071220115816.504CC26F98E@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220115816.504CC26F98E@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 03:58:16AM -0800, Roland McGrath wrote:
> +obj-$(CONFIG_PPC64)		+= ../../../fs/compat_binfmt_elf.o

Building files from another directory is nasty.  Please add a
CONFIG_BINFMT_COMPAT_ELF so we can simply build it in fs/

