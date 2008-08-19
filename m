Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYHSHrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYHSHrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYHSHrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:47:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46475 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYHSHrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:47:00 -0400
Date: Tue, 19 Aug 2008 09:48:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use function calls [POST 2]
Message-ID: <20080819074846.GE9807@one.firstfloor.org>
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu> <20080819073214.GD9807@one.firstfloor.org> <48AA79C4.8060309@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AA79C4.8060309@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Don't pay attention to that number.  It's only the extra latency of a HT
> context->HT context function call + tlb flush.  Which means 1) the tlb
> is shared anyway, so the extra flush is redundant, 2) they're not really
> concurrent, 3) it's going down the single-cpu call, rather than the
> multi-cpu one, 4) it's only measuring the latency for a particular tlb
> flush, and doesn't take into account any throughput improvements the
> extra queueing may add.

A lot of flushes are synchronous. See the rest of my email that
you snipped.

-Andi
