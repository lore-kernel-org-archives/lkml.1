Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZATOlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZATOlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZATOlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:41:15 -0500
Received: from mx1.suse.de ([195.135.220.2]:36549 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbZATOlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:41:14 -0500
Date: Tue, 20 Jan 2009 15:41:09 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090120144109.GK19505@wotan.suse.de>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu> <20090120141454.GI19505@wotan.suse.de> <20090120141735.GA9474@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120141735.GA9474@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 03:17:35PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > BTW. the lmbench test I run directly (it's called lat_mmap.c, and gets 
> > compiled into a standalone lat_mmap exec by the standard lmbench build).
> 
> doesnt that include an indeterminate number of gettimeofday() based 
> calibration calls? That would make it harder to measure its total costs in 
> a comparative way.

Hmm... yes probably for really detailed profile comparisons or
other external measurements it would need modification.
