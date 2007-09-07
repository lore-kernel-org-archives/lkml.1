Return-Path: <linux-kernel-owner+w=401wt.eu-S965562AbXIGQSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562AbXIGQSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbXIGQR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:17:59 -0400
Received: from THUNK.ORG ([69.25.196.29]:45903 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437AbXIGQR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:17:58 -0400
Date: Fri, 7 Sep 2007 12:04:45 -0400
From: Theodore Tso <tytso@mit.edu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070907160445.GB8911@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org
References: <20070906200733.194442762@polymtl.ca> <20070906200825.893834634@polymtl.ca> <20070906160001.cfe48d78.randy.dunlap@oracle.com> <20070906160429.629c9497.akpm@linux-foundation.org> <20070906163737.9cc91307.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906163737.9cc91307.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:37:37PM -0700, Randy Dunlap wrote:
> Thanks.  I look forward to the explanation of Reviewed-by, what it
> means, and how it differs from Acked-by.

This was proposed by Andrew and discussed at the Kernel Summit; the
basic idea is that it is a formal indication that the person has done
a *full* review of the patch (a few random comments from the local
whitespace police don't count), and is willing to vouch that the patch
is correct, safe, extremely unlikely to cause regressions, etc.  If
the patch does need to be reverted or fixed because it was buggy, then
both the original submitter and the reviewer would bear responsibility
and subsystem maintainers might take that into account when assessing
the reputations of the submitter and reviewer in the future when
deciding whether or not to accept a patch.

Basically, some people seem to be using "Acked-by" to mean, "seems
good to me", without necessarily doing a full review of the patch, and
instead of trying to change the meaning of "Acked-by", to have a new
sign off which is a bit more explicitly about what it means.  (Hmmm,
thinking about it afterwards, maybe "Vouched-by:" would be even
better....)

There was some thought about negative attention (i.e., "public
mockery") given to people who sign off on a patch via Reviewed-by:
that subsequently turns out to be buggy or cause a regression, but the
concern with that is that we have enough trouble finding people to
review patches, and we wouldn't want to scare off reviewers.  But it
would be fair to say that the consequences of reviewing patches
successfully or unsuccessfully would naturally impact people's
reputations.

There was also some discussion about whether or not patches would not
be accepted at all without a Reviewed-by, but that probably won't
happen initially.  The general consensus was to gently ease into it
and see how well it works first.

        					- Ted
