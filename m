Return-Path: <linux-kernel-owner+w=401wt.eu-S1763881AbXKTWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763881AbXKTWqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759848AbXKTWqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:46:13 -0500
Received: from pat.uio.no ([129.240.10.15]:37046 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250AbXKTWqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:46:12 -0500
Subject: Re: [rfc 19/45] cpu alloc: NFS statistics
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <clameter@sgi.com>, ak@suse.de,
       akpm@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071120215048.GA14522@Krystal>
References: <20071120011132.143632442@sgi.com>
	 <20071120011336.210236732@sgi.com> <20071120130201.GE10127@Krystal>
	 <Pine.LNX.4.64.0711201248330.26745@schroedinger.engr.sgi.com>
	 <1195592198.7234.45.camel@heimdal.trondhjem.org>
	 <20071120212834.GC11291@Krystal>
	 <1195595283.7234.50.camel@heimdal.trondhjem.org>
	 <20071120215048.GA14522@Krystal>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 17:46:42 -0500
Message-Id: <1195598802.7234.87.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.141)
X-UiO-Scanned: 6DE152A2038A65E3F07CAF93C017991568A430CC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 577 total 5263878 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-20 at 16:50 -0500, Mathieu Desnoyers wrote:
> Then my original point is valid : put_no_resched() will cause unwanted
> scheduler latencies. It's designed only to be used from within the
> scheduler code itself. The correct approach would be a standard
> put_cpu().
> 
> Or am I missing something ?

Then someone who cares about scheduler latency had better audit the code
and figure out which calls are made under spinlock, and which aren't:
it's not on my personal list of high priorities. I'll be happy to review
any patches, though.

Trond

