Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYJZOlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYJZOlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYJZOlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:41:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYJZOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:41:04 -0400
Subject: Re: [PATCH] Rename DECLARE_MUTEX to DEFINE_SEMAPHORE
From: Peter Zijlstra <peterz@infradead.org>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <c384c5ea0810260711l1103a103j6c3739fe3a8d9e74@mail.gmail.com>
References: <20081026120609.GA10728@joi> <1225028346.32713.11.camel@twins>
	 <c384c5ea0810260711l1103a103j6c3739fe3a8d9e74@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 26 Oct 2008 15:41:03 +0100
Message-Id: <1225032063.32713.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-26 at 15:11 +0100, Leon Woestenberg wrote:
> Hello,
> 
> On Sun, Oct 26, 2008 at 2:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Sun, 2008-10-26 at 13:06 +0100, Marcin Slusarz wrote:
> >> DECLARE_MUTEX is doubly misleading name (it actually _defines_ struct
> >> _semaphore_ initialized to 1) and it can be confused with DEFINE_MUTEX
> >> (which defines real struct mutex). Rename it.
> >
> > I'd prefer DEFINE_BINARY_SEM or somesuch
> >
> But it is not a binary semaphore, or is it?

> #define DECLARE_MUTEX(name) __DECLARE_SEMAPHORE_GENERIC(name,1)

I thought that 1 made it a binary sem.
