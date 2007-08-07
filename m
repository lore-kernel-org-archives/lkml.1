Return-Path: <linux-kernel-owner+w=401wt.eu-S934431AbXHGU3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbXHGU3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXHGU3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:29:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbXHGU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:29:35 -0400
Date: Tue, 7 Aug 2007 13:28:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add linux/elfcore-compat.h
Message-Id: <20070807132850.a7e81f97.akpm@linux-foundation.org>
In-Reply-To: <20070803232121.A252E4D04BC@magilla.localdomain>
References: <20070803232121.A252E4D04BC@magilla.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Aug 2007 16:21:21 -0700 (PDT)
Roland McGrath <roland@redhat.com> wrote:

> This adds the linux/elfcore-compat.h header file, which is the
> CONFIG_COMPAT analog of the linux/elfcore.h header.  Each arch
> that needs to fake out fs/binfmt_elf.c for its compat code can
> use this header to replace the hand-copied definitions of the
> compat variants of struct elf_prstatus et al.  Only the pr_reg
> field varies by arch, so asm/{compat,elf}.h must define
> compat_elf_gregset_t before linux/elfcore-compat.h can be used.
> 

Should ia64 be using this too?
