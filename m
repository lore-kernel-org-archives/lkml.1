Return-Path: <linux-kernel-owner+w=401wt.eu-S1762930AbXLUOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762930AbXLUOS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXLUOSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:18:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbXLUOSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:18:15 -0500
Date: Fri, 21 Dec 2007 09:17:53 -0500
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
Message-ID: <20071221091753.15a18935@bree.surriel.com>
In-Reply-To: <200712212152.19260.nickpiggin@yahoo.com.au>
References: <20071218211539.250334036@redhat.com>
	<1198080267.5333.22.camel@localhost>
	<20071220155627.6872b0e6@bree.surriel.com>
	<200712212152.19260.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 21:52:19 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> BTW. if you have any workloads that are limited by page reclaim,
> especially unmapped file backed pagecache reclaim, then I have some
> stright-line-speedup patches which you might find interesting (I can
> send them if you'd like to test).

I am definately interested in those.

The current upstream VM seems to be fairly good in steady state,
with the largest problems happening when the system switches states
(eg. from reclaiming page cache to swapping), but any speedups in
the steady state are good too.
