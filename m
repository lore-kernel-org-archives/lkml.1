Return-Path: <linux-kernel-owner+w=401wt.eu-S1762714AbYCEHHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762714AbYCEHHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYCEHHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:07:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYCEHHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:07:32 -0500
Date: Wed, 5 Mar 2008 08:07:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pageattr.c fix shadowed variable warning
Message-ID: <20080305070719.GC32434@elte.hu>
References: <1204697127.17484.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204697127.17484.1.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> irqs_disabled() uses flags internally, use _flags to avoid shadowing 
> code calling into this macro.

thanks Harvey, applied.

	Ingo
