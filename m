Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYHSKVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYHSKVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYHSKVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:21:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35292 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbYHSKVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:21:05 -0400
Date: Tue, 19 Aug 2008 12:20:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
	to use function calls [POST 2]
Message-ID: <20080819102045.GC6722@elte.hu>
References: <patchbomb.1219083817@localhost> <48AA5C19.3010204@goop.org> <20080819093130.GF28713@elte.hu> <200808191956.59898.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808191956.59898.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> I'm especially sore about mmap because I have a customer with a 
> database that uses a lot of mmap/munmap and those calls have slowed 
> down something like 50%(!!) from 2.6.early to 2.6.late.

oh, agreed that it all needs to speed up - please send testcases ...

	Ingo
