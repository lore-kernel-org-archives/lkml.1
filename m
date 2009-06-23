Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbZFWWk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbZFWWk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZFWWkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:40:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54553 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbZFWWkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:40:14 -0400
Date: Tue, 23 Jun 2009 21:24:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Cc: James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: [PATCH 0/1] mm_for_maps: simplify, use ptrace_may_access()
Message-ID: <20090623192451.GA27853@redhat.com>
References: <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu> <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org> <20090623141451.GA8133@redhat.com> <20090623174918.GA24430@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623174918.GA24430@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Christoph Hellwig wrote:
>
> Umm, I think I mentioned it before:  if you really need to rename that
> beast please kill the ptrace part as we use it for all kinds of other
> things.

Agreed, it would be nice to rename (and move out of ptrace.c) but I am
not going to do this, I can't suggest the better naming.

But I think it would be nice to kill __ptrace_may_access() and use
ptrace_may_access() everywhere. ptrace_attach() is trivial, the only
other caller is mm_for_maps().

Oleg.

