Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbZHZBao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbZHZBao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZHZBao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:30:44 -0400
Received: from thunk.org ([69.25.196.29]:49972 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbZHZBan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:30:43 -0400
Date: Tue, 25 Aug 2009 21:30:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Shanab <jshanab@earthlink.net>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Starting a grad project that may change kernel VFS. Early
	research Re: Starting a grad project that may change kernel VFS.
	Early  research
Message-ID: <20090826013043.GB17684@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Shanab <jshanab@earthlink.net>, Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org
References: <4A93428A.4070903@earthlink.net> <4A941F56.8060502@redhat.com> <4A9427C7.8020009@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9427C7.8020009@earthlink.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something which I urge you to think about is whether optimizing du -s
is really worth it; this is not at all obvious.  If it's going to cost
performance; if it's going to require non-backwards compatible changes
to filesystems; if it means introducing changes to the semantics of
hard links --- please *seriously* consider whether or not it's worth
it.

In what workload or use case is "du -s" something that gets done
frequently?  And is it really worth adding code complexity and slowing
down much more common operations, such as writing files?

If the goal is do a project that gets you a master's degree or a
Ph.D., ok, fine; there are plenty of academic degrees and honors which
are given for ideas that are completely impractical and/or useless in
the real world.

If your goal is to create a feature that will be accepted into
mainline, then you need to provide a lot more justification that this
is actually a good and worthwhile thing to do, and that the benefits
outweigh the costs (in code complexity, long-term maintenance,
performance regressions, etc.)

						- Ted
