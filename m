Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbXIRRoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbXIRRoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760522AbXIRRoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:44:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbXIRRop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:44:45 -0400
Date: Tue, 18 Sep 2007 10:44:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: use pagevec to rotate reclaimable page
Message-Id: <20070918104435.2ba25ff3.akpm@linux-foundation.org>
In-Reply-To: <200709181129.50253.nickpiggin@yahoo.com.au>
References: <6.0.0.20.2.20070907113025.024dfbb8@172.19.0.2>
	<20070913193711.ecc825f7.akpm@linux-foundation.org>
	<6.0.0.20.2.20070918193944.038e2ea0@172.19.0.2>
	<200709181129.50253.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 11:29:50 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> It would be interesting to test -mm kernels. They have a patch which reduces
> zone lock contention quite a lot.

They do?  Which patch?

> I think your patch is a nice idea, and with less zone lock contention in other
> areas, it is possible that it might produce a relatively larger improvement.

I'm a bit wobbly about this patch - it adds additional single-cpu overhead
to reduce multiple-cpu overhead and latency.
