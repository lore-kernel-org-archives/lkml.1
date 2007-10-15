Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbXJOX2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbXJOX2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbXJOX2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:28:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbXJOX2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:28:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200710161146.33508.nickpiggin@yahoo.com.au>
References: <200710161146.33508.nickpiggin@yahoo.com.au> <1192451324.27435.71.camel@twins> <20071011213126.cf92efb7.akpm@linux-foundation.org> <21859.1192457172@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: nfs mmap adventure (was: 2.6.23-mm1)
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 16 Oct 2007 00:27:37 +0100
Message-ID: <26154.1192490857@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> I don't think the fault handler is currently in any position to do
> that ATM. It is possible to make it interruptible in some contexts,
> but faults from kernel code may not be able to cope.

Hmmm...  Good point.  Yuck.

David
