Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZBQPY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZBQPY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZBQPYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:24:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40811 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZBQPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:24:49 -0500
Date: Tue, 17 Feb 2009 10:24:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kazuto Miyoshi <miyoshi@linux.bs1.fc.nec.co.jp>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] Add tracepoints to track pagecache transition
In-Reply-To: <499A99BC.2080700@bk.jp.nec.com>
Message-ID: <alpine.DEB.1.10.0902171021320.910@gandalf.stny.rr.com>
References: <499A7CAD.9030409@bk.jp.nec.com> <1234863220.4744.34.camel@laptop> <499A99BC.2080700@bk.jp.nec.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Feb 2009, Atsushi Tsuji wrote:
> > 
> > This is rather asymmetric, why don't we care about the offset for the
> > removed page?
> > 
> 
> Indeed.
> I added the offset to the argument for the removed page and resend fixed patch.
> 
> Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>

Could you package it up in one patch again and resend with [PATCH v2].
Also make sure to Cc the memory folks, and ask for an Acked-by from them.

Thanks,

-- Steve
