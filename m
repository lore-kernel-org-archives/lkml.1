Return-Path: <linux-kernel-owner+w=401wt.eu-S1762438AbZLPT7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762438AbZLPT7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbZLPT7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:59:37 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40297 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbZLPT7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:59:37 -0500
Date: Wed, 16 Dec 2009 12:59:35 -0700
From: Alex Chiang <achiang@hp.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Message-ID: <20091216195935.GA551@ldl.fc.hp.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've no comments on the actual patch but...

* Mikulas Patocka <mpatocka@redhat.com>:
> Drop 80-character limit in checkpatch.pl
> 
> Serious issues:
> ===============
> 
> (1) The code is hard to edit with common text editors

You mention vi; most distros provide vim these days.

In my .vimrc, I have:

	set ai
	set si

That helps a bit.

> (2) Grepping the code is unreliable

Reviewers (at least in my part of the kernel) have been
requesting that user-visible (and thus developer greppable)
output be combined on one line precisely for this reason.

We've been rejecting patches that unnecessarily break up these
strings at 80 cols.

> But some maintainers take output of the script checkpatch.pl
> dogmatically, requiring that every new work must pass the
> script without a warning.

This is the real problem. And I think the solution is to lobby
your maintainer.

fwiw,
/ac

