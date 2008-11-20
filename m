Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYKTQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYKTQg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYKTQgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:36:17 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:41303 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYKTQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:36:17 -0500
Date: Thu, 20 Nov 2008 10:35:05 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] cpu alloc cleanups and implementation improvement
In-Reply-To: <200811172353.18356.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0811201030240.19948@quilx.com>
References: <200811172353.18356.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Rusty Russell wrote:

>   I've argued with Christoph that his implementation contains gratuitous
> obsolescence of perfectly-good APIs; hopefully providing real patches will
> give us a more useful debate.

I would not mind if you would take over from here. It seems that I
am into too many things again. Then you can also do the lower
casing that I find inconsistent.

> I hope this adds some light,

As I pointed out before there are numerous semantic differences that I
noted before. For the transition period where the percpu allocator has a
fixed area there will be issues with an immediate conversion because the
existing allocpercpu allows unbounded allocations and the cpualloc does
not.

