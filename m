Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYLCA7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYLCA7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYLCA7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:59:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbYLCA7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:59:33 -0500
Date: Tue, 2 Dec 2008 16:57:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: cl@linux-foundation.org, rja@sgi.com, nickpiggin@yahoo.com.au,
       davej@redhat.com, arjan@infradead.org, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/8] badpage: simplify page_alloc flag check+clear
Message-Id: <20081202165755.0306b56f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0812021357390.28623@blonde.anvils>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
	<Pine.LNX.4.64.0812010038220.11401@blonde.site>
	<Pine.LNX.4.64.0812010843230.15331@quilx.com>
	<Pine.LNX.4.64.0812012349330.18893@blonde.anvils>
	<Pine.LNX.4.64.0812012014150.30344@quilx.com>
	<Pine.LNX.4.64.0812020947440.5306@blonde.anvils>
	<Pine.LNX.4.64.0812020710371.9474@quilx.com>
	<Pine.LNX.4.64.0812021357390.28623@blonde.anvils>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 14:12:05 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> On Tue, 2 Dec 2008, Christoph Lameter wrote:
> > On Tue, 2 Dec 2008, Hugh Dickins wrote:
> > 
> > > > But they are always clear on free. The checking is irrelevant.
> > >
> > > How about CHECK_PAGE_FLAGS_CLEAR_AT_FREE?
> > 
> > Strange name.
> 
> Looks like I'm not going to be able to satisfy you then.  I didn't
> introduce the names in the patch, so let's leave them as is for now,
> and everybody can muse on what they should get called in the end.

It's unclear to me where your discussion with Christoph ended up, so I
went the merge-it-and-see-who-shouts-at-me route.

