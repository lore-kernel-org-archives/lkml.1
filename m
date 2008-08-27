Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYH0A0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYH0A0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYH0A0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:26:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYH0A0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:26:16 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
References: <20080826220102.89635154233@magilla.localdomain>
	<20080826223402.GB27724@x200.localdomain>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 26 Aug 2008 20:17:12 -0400
In-Reply-To: <20080826223402.GB27724@x200.localdomain> (Alexey Dobriyan's message of "Wed, 27 Aug 2008 02:34:03 +0400")
Message-ID: <y0m7ia3xqev.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexey Dobriyan <adobriyan@gmail.com> writes:

> [...]  And some internal details still horrible and overdesigned
> just like at the very beginning.

Please point out specific areas, and I'm sure there will be a reasonable
explanation why they turned out this way.

As for whether "struct utrace" should be a member of vs. pointed-to
from task_struct, it may come down to the perceived need to avoid
penalizing every thread with a hundred-odd bytes extra, whether or not
they are being utrace-controlled.


> [...]  Linked list of attached tracers? I don't know.  One the bad
> side, where are those nice tracing modules? Where are they?

Among others, utrace is an enablement layer for systemtap user-space
probing, through another subsequent part that implements a
kprobes-like API for user-space tasks.  All this code now exists in at
least prototype form, so if you need to see the bigger picture, look
that way.  Other users are anticipated, but first we need to get past
the chicken-and-egg.


> This all similar to systemtap/markers story. Big changes under
> promises that now, now somebody will use our thing.

In what way do you think those promises are unfulfilled?  Systemtap
has interfaced to markers since the beginning, and there are a bunch
of markers in the tree.


- FChE
