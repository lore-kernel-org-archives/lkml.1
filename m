Return-Path: <linux-kernel-owner+w=401wt.eu-S1422639AbXCGJLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422639AbXCGJLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422637AbXCGJLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:11:35 -0500
Received: from mail.suse.de ([195.135.220.2]:36307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422639AbXCGJLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:11:34 -0500
Date: Wed, 7 Mar 2007 10:11:32 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307091132.GB17433@wotan.suse.de>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307085944.GA17433@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307085944.GA17433@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 09:59:44AM +0100, Nick Piggin wrote:
> Apart from a handful of trivial if (pte_file()) cases throughout mm/,
> our maintainance burden basically now amounts to the following patch.
> Even the rmap.c change looks bigger than it is because I split out
> the nonlinear unmapping code from try_to_unmap_file. Not too bad, eh? :)

Oh, there is a bit more nonlinear mmap list manipulation I'd forgotten
about too... makes things a little bit worse, but not too much.
