Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXC2BSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXC2BSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 21:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXC2BSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 21:18:09 -0400
Received: from kanga.kvack.org ([66.96.29.28]:60272 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbXC2BSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 21:18:08 -0400
Date: Wed, 28 Mar 2007 21:17:51 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070329011751.GC17334@kvack.org>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328134511.0d61ec8f.akpm@linux-foundation.org> <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 02:05:54PM -0700, Christoph Lameter wrote:
> Tried this also on x86_64 with an enhanced quicklist patch that also deals 
> with ptes (at the price of not guaranteeing the free after the tlb flush):
...
> Seems that there is a slight benefit but its also barely above noise 
> level.

You're not running a test that will show any benefit in this area.  Run 
some heavy shell scripts or lmbench's fork() and exec() latency tests 
to get real numbers.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
