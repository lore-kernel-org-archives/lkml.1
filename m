Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZJZG0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZJZG0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 02:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZJZG0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 02:26:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbZJZG0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 02:26:43 -0400
Date: Mon, 26 Oct 2009 07:25:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Kill off -Wcast-align
Message-ID: <20091026062520.GA29580@elte.hu>
References: <20091026054000.GA13517@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026054000.GA13517@linux-sh.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mundt <lethal@linux-sh.org> wrote:

> The present use of -Wcast-align causes the build to blow up on SH due to
> generating a "cast increases required alignment of target type" error on
> each invocation of list_for_each_entry().
> 
> It seems that this was previously reported and killed off in the ia64
> support patch, but nothing seems to have happened with that. Presumably
> the same problem still remains there, too.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Is this a GCC bug producing false positive warnings? The GCC manpage 
says:

       -Wcast-align
           Warn whenever a pointer is cast such that the required alignment of the
           target is increased.  For example, warn if a "char *" is cast to an
           "int *" on machines where integers can only be accessed at two- or
           four-byte boundaries.

Which looks moderately useful - if it works.

	Ingo
