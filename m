Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbXKLPex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbXKLPex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXKLPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:34:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXKLPep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:34:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071110181416.31dc2614.akpm@linux-foundation.org>
References: <20071110181416.31dc2614.akpm@linux-foundation.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 12 Nov 2007 15:34:40 +0000
Message-ID: <6214.1194881680@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +# -*- makefile -*-
> 
> what's that?

Ah...  That tells emacs that it's a makefile.  In Kbuild.asm emacs thinks its
an Assembly file and not a makefile.  This causes it to attempt to do
automatic indentation on it.  Do you want me to drop these annotation
comments?

> Note that because of unexport-asm-pageh.patch I turned the above hunk into
> 
> ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
> unifdef-y += a.out.h
> endif
> 
> which seems logical to me.  We'll see how it tests out.

Are you talking about in linux/Kbuild or in asm-generic/Kbuild.asm or both?

Anyway, it sounds reasonable.

David
