Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbXKNV1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbXKNV1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXKNV1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:27:31 -0500
Received: from pat.uio.no ([129.240.10.15]:33875 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbXKNV13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:27:29 -0500
Subject: Re: [PATCH 0/3] mmap vs NFS
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20071114200136.009242000@chello.nl>
References: <20071114200136.009242000@chello.nl>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 16:27:32 -0500
Message-Id: <1195075652.7584.61.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.1, required=12.0, autolearn=disabled, AWL=0.072)
X-UiO-Scanned: 27D0CAF22A11F00001FEF1DE65A80272F33E56CD
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 1 maxlevel 200 minaction 2 bait 0 mail/h: 497 total 5136496 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 21:01 +0100, Peter Zijlstra wrote:
> Currently there is an AB-BA deadlock in NFS mmap.
> 
> nfs_file_mmap() can take i_mutex, while holding mmap_sem, whereas the regular
> locking order is the other way around.
> 
> This patch-set attempts to solve this issue.

Looks good from the NFS point of view.

Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>

