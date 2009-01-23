Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZAWUQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZAWUQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 15:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZAWUQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 15:16:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49370 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbZAWUQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 15:16:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1232728669.4826.143.camel@laptop>
References: <1232728669.4826.143.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       L-K <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] x86,mm: fix pte_free()
Date: Fri, 23 Jan 2009 20:15:04 +0000
Message-ID: <29744.1232741704@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> It seems all architectures except x86 and nm10300 already do this, and
> nm10300 doesn't seem to use pgtable_page_ctor(), which suggests it
> doesn't do SMP or simply doesnt do MMU at all or something.

MN10300 does not, as yet, do SMP.

David
