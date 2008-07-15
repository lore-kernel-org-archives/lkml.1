Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbYGOVsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbYGOVsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYGOVsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:48:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42216 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbYGOVsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:48:39 -0400
Date: Tue, 15 Jul 2008 23:48:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] generic ipi function calls: wait on alloc failure
	fallback
Message-ID: <20080715214819.GA23588@elte.hu>
References: <487D0719.9000503@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D0719.9000503@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When a GFP_ATOMIC allocation fails, it falls back to allocating the 
> data on the stack and converting it to a waiting call.
>
> Make sure we actually wait in this case.

cool, thanks!

does this explain the xen64 weirdnesses you've been seeing?

	Ingo
