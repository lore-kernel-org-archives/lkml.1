Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZBQLyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZBQLyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZBQLyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:54:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZBQLyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:54:39 -0500
Subject: Re: [PATCH] Add tracepoints to track pagecache transition
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kazuto Miyoshi <miyoshi@linux.bs1.fc.nec.co.jp>, rostedt@goodmis.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <20090217201651.576E.A69D9226@jp.fujitsu.com>
References: <1234863220.4744.34.camel@laptop>
	 <499A99BC.2080700@bk.jp.nec.com>
	 <20090217201651.576E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 12:54:11 +0100
Message-Id: <1234871651.4744.89.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 20:38 +0900, KOSAKI Motohiro wrote:
> If you want to see I/O activity, you need to add tracepoint into block
> layer.

We already have that, Arnaldo converted blktrace to use tracepoints and
wrote an ftrace tracer for it.

