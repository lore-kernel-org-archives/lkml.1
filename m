Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbYE1PtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYE1PtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 11:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYE1PtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 11:49:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbYE1PtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 11:49:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080528143634.29463.2720.stgit@warthog.procyon.org.uk>
References: <20080528143634.29463.2720.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Specify the minimum slab/kmalloc alignment
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 May 2008 16:49:01 +0100
Message-ID: <25268.1211989741@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +#define	ARCH_KMALLOC_MINALIGN		(sizeof(long) * 2)
> +#define	ARCH_SLAB_MINALIGN		(sizeof(long) * 2)

This doesn't work if SLAB is selected and slab debugging is enabled as these
are passed to the preprocessor.

David
