Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYDVIsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYDVIsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbYDVIsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:48:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbYDVIsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:48:05 -0400
Date: Tue, 22 Apr 2008 10:47:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
	calls
Message-ID: <20080422084738.GB2388@elte.hu>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208851058-8500-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> This converts x86 and x86-64 to use the new helpers for 
> smp_call_function() and friends, and adds support for 
> smp_call_function_single().

nice stuff. The x86 and generic bits:

 Acked-by: Ingo Molnar <mingo@elte.hu>

this has been brewing for months, what is the testing/confidence status 
of it? Could we still merge it into v2.6.26? (i think we should)

	Ingo
