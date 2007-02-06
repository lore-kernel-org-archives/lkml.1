Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbXBFI7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbXBFI7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXBFI7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:59:05 -0500
Received: from mx1.suse.de ([195.135.220.2]:59441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbXBFI6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:58:54 -0500
Date: Tue, 6 Feb 2007 09:58:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: Re: [patch 3/3] mm: make read_cache_page synchronous
Message-ID: <20070206085847.GA6487@wotan.suse.de>
References: <20070206054925.21042.50546.sendpatchset@linux.site> <20070206054957.21042.18724.sendpatchset@linux.site> <20070206002839.f02a47bc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206002839.f02a47bc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 12:28:39AM -0800, Andrew Morton wrote:
> > 
> > Also, a memory leak in sys_swapon().
> 
> Separate patch?

Gack, I'm an idiot, there is no memory leak :P
