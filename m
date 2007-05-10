Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbXEJJVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbXEJJVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757470AbXEJJUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:20:49 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41481
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734AbXEJJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:20:47 -0400
From: Rob Landley <rob@landley.net>
To: "Ollie Wild" <aaw@google.com>
Subject: Re: [patch] removes MAX_ARG_PAGES
Date: Thu, 10 May 2007 05:19:37 -0400
User-Agent: KMail/1.9.1
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>
References: <65dd6fd50705060151m78bb9b4fpcb941b16a8c4709e@mail.gmail.com> <200705092104.43353.rob@landley.net> <65dd6fd50705092106i15722e97g85f43191ceb5a3d7@mail.gmail.com>
In-Reply-To: <65dd6fd50705092106i15722e97g85f43191ceb5a3d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705100519.38073.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007 12:06 am, Ollie Wild wrote:
> On 5/9/07, Rob Landley <rob@landley.net> wrote:
> > Just FYI, a really really quick and dirty way of testing this sort of 
thing on
> > more architectures and you're likely to physically have?
> 
> Does this properly emulate caching?  On parisc, cache coherency was
> the main issue we ran into.  I suspect this might be the case with
> other architectures as well.

This is really a QEMU question.  I've been focused on making cross-compilers 
and using those to create kernels and a minimal native build environment I 
could use to natively compile packages with.  (The way I designed the thing 
you could substitute real hardware for the qemu step, assuming you had it.  
Or another emulator like armulator for a specific platform.)

I don't believe QEMU emulates parisc yet, although it adds new platforms all 
the time.  (It just grew an alpha emulation last month.)  It's under very 
active development.

Rob
