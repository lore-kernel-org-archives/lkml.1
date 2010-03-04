Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0CDRPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:15:47 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:49270 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab0CDRPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:15:45 -0500
Date: Thu, 4 Mar 2010 12:18:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [RFC PATCH 0/7] perf: 'live mode'
Message-ID: <20100304111856.GE21977@elte.hu>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> Currently, a perf session entails two steps: first 'perf record' or 'perf 
> trace record' records the perf data to disk, then 'perf report' or 'perf 
> trace report' reads the saved data from disk and reports the results.
> 
> This experimental patchset makes some changes to perf that instead allow the 
> perf data to be piped directly from the record step to the report step, 
> without ever touching the disk.

Very nice!

> Obviously, it would be better to have a real top-like display for these 
> rather than a continuously scrolling mode like this, and of course it will 
> be much more useful once we get the syscall name injection events going (the 
> column on the left shows syscall numbers only).

It's still useful for ad-hoc tracing!

Side-note, it might make sense to expose the 'clear' escape sequence somehow 
in an easy fashion:

[H[2J

to make it non-scrolling ;-) via a pre-provided method.

> There are some rough edges and inefficiencies, and I guess 'event injection' 
> may be a better way to do this in the end, but it seems to work pretty well 
> already, and I think it shows how useful such a capability can be.

I'm all for it. Frederic, Steve, what do you think?

	Ingo
