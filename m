Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYJHHh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYJHHh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYJHHhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:37:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45802 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYJHHhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:37:17 -0400
Subject: Re: [BUG] SLOB's krealloc() seems bust
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
In-Reply-To: <84144f020810080025o348ae189vab83f1620b2e9560@mail.gmail.com>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
	 <1223441190.13453.459.camel@calx>
	 <200810081554.33651.nickpiggin@yahoo.com.au>
	 <200810081611.30897.nickpiggin@yahoo.com.au>
	 <1223442947.13453.462.camel@calx>
	 <1223448220.1378.13.camel@lappy.programming.kicks-ass.net>
	 <84144f020810080025o348ae189vab83f1620b2e9560@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 09:37:13 +0200
Message-Id: <1223451433.1378.29.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 10:25 +0300, Pekka Enberg wrote:
> Hi Peter,
> 
> On Wed, 2008-10-08 at 00:15 -0500, Matt Mackall wrote:
> >> Damnit, how many ways can we get confused by these little details? I'll
> >> spin a final version and run it against the test harness shortly.
> 
> On Wed, Oct 8, 2008 at 9:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > So I'll wait with testing for the next version?
> 
> AFAICT, this should be fine:
> 
> http://lkml.org/lkml/2008/10/7/436
> 
> You need to revert the patch Linus already committed before applying
> that though.

Or not have pulled it yet ;-)

Anyway, that patch seems to be good on 4 boots.

