Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759AbYK2Jj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbYK2Jj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 04:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYK2Jju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 04:39:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbYK2Jjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 04:39:49 -0500
Date: Sat, 29 Nov 2008 01:39:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jirka Pirko <jirka@pirko.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get rid of some "may be used uninitialized" compiler
 warnings
Message-Id: <20081129013928.1bb41320.akpm@linux-foundation.org>
In-Reply-To: <20081129092601.GA26691@elte.hu>
References: <20081129003347.2295622f@jirka.pirko.cz>
	<20081129092601.GA26691@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 10:26:01 +0100 Ingo Molnar <mingo@elte.hu> wrote:

>  196 files changed, 545 insertions(+), 436 deletions(-)

Is any of this going anywhere?

There's a lot of resistance to fixing these things with
uninitialized_var() (usually bogus resistance, IMO, but one
gets tired of repeating oneself).

Many of these warnings can be fixed by restructuring the code, and
often the end result is better overall.

But it's a lot more work.  It would be much more scalable to, umm,
motivate the various code-owners to fix their stuff independently.  I
don't know how, really - people just don't seem to appreciate how
irritating and damaging that great warning spew is.

Is there any prospect that some of these things will be fixed by newer
gcc versions?  If so, we could just ignore those warnings and
concentrate on the ones which newer gcc emits.
