Return-Path: <linux-kernel-owner+w=401wt.eu-S1030779AbXCTAHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030779AbXCTAHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030780AbXCTAHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:07:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030779AbXCTAHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:07:48 -0400
Date: Mon, 19 Mar 2007 17:07:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
Message-Id: <20070319170741.5a24af4c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703191655190.13879@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
	<20070319165329.b5830789.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703191655190.13879@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 16:57:55 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Mon, 19 Mar 2007, Andrew Morton wrote:
> 
> > Has it been proven that quicklists are superior to simply going direct to the
> > page allocator for these pages?
> 
> Yes.

Sigh.

Please provide proof that quicklists are superior to simply going direct to
the page allocator for these pages.

> > Would it provide a superior solution if we were to a) stop zeroing out the
> > pte's when doing a fullmm==1 teardown and b) go direct to the page allocator
> > for these pages?
> 
> I doubt it. The zeroing is a by product of our way of serializing pte 
> handling. Its going to be difficult to change that.

Nick didn't think so, and I don't see the problem either.

We'll save on some bus traffic by avoiding the writeback, but how much
effect that will have we don't know.  Presumably little.

