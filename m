Return-Path: <linux-kernel-owner+w=401wt.eu-S934978AbXG0JoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978AbXG0JoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763815AbXG0JoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:44:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760735AbXG0JoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:44:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1185493838.5495.144.camel@localhost.localdomain>
References: <1185493838.5495.144.camel@localhost.localdomain>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] remove frv usage of flush_tlb_pgtables()
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 27 Jul 2007 10:43:58 +0100
Message-ID: <21776.1185529438@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> frv is the last user in the tree of that dubious hook, and it's my
> understanding that it's not even needed. It's only called by memory.c
> free_pgd_range() which is always called within an mmu_gather, and
> tlb_flush() on frv will do a flush_tlb_mm(), which from my reading
> of the code, seems to do what flush_tlb_ptables() does, which is
> to clear the cached PGE.

Yeah...  I hadn't got around to killing myself yet.

Acked-By: David Howells <dhowells@redhat.com>
