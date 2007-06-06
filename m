Return-Path: <linux-kernel-owner+w=401wt.eu-S935156AbXFFTMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156AbXFFTMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761375AbXFFTMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:12:40 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:37045 "EHLO
	viefep28-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755973AbXFFTMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:12:39 -0400
Subject: Re: [PATCH 3/4] mm: move_page_tables{,_up}
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ollie Wild <aaw@google.com>
Cc: linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <65dd6fd50706061206y558e7f90t3740424fae7bdc9c@mail.gmail.com>
References: <20070605150523.786600000@chello.nl>
	 <20070605151203.738393000@chello.nl>
	 <65dd6fd50706061206y558e7f90t3740424fae7bdc9c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 21:12:14 +0200
Message-Id: <1181157134.5676.28.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 12:06 -0700, Ollie Wild wrote:
> On 6/5/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Provide functions for moving page tables upwards.
> 
> Now that we're initializing the temporary stack location to
> STACK_TOP_MAX, do we still need move_page_tables_up() for variable
> length argument support?  I originally added it into shift_arg_pages()
> to support 32-bit apps exec'ing 64-bit apps when we were using
> TASK_SIZE as our temporary location.
> 
> Maybe we should decouple this patch from the others and submit it as
> an enhancement to support memory defragmentation.

PA-RISC will still need it, right?

On the defrag thingy, I talked with Mel today, and neither of us can see
a usefull application of these functions to his defrag work.

