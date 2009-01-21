Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbZAUNUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbZAUNUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZAUNUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:20:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbZAUNUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:20:41 -0500
Date: Wed, 21 Jan 2009 14:20:36 +0100
From: Nick Piggin <npiggin@suse.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, yinghai@kernel.org,
       venkatesh.pallipadi@intel.com, akpm@linux-foundation.org,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       jaswinderlinux@gmail.com, just.for.lkml@googlemail.com
Subject: Re: [patch] x86: fix page attribute corruption with cpa()
Message-ID: <20090121132036.GU24891@wotan.suse.de>
References: <20090120222021.GB28352@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120222021.GB28352@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 02:20:21PM -0800, Suresh B wrote:
> This patch fixes a performance issue reported by Linus on his
> Nehalem system. While Linus reverted the PAT patch (commit
> 58dab916dfb57328d50deb0aa9b3fc92efa248ff) which exposed the issue,
> existing cpa() code can potentially still cause wrong(page attribute
> corruption) behavior.
> 
> This patch also fixes the "WARNING: at arch/x86/mm/pageattr.c:560" that
> various people reported.

This doesn't seem to show up any more after running the system for
some time, so I think it's fixed here. Thanks!

> 
> ---
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86: fix page attribute corruption with cpa()

