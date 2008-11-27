Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYK0JOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYK0JOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYK0JOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:14:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYK0JOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:14:21 -0500
Date: Thu, 27 Nov 2008 10:14:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/1] ring-buffer fix for 2.6.28
Message-ID: <20081127091408.GB26093@elte.hu>
References: <20081127025227.026028481@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127025227.026028481@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The following patch needs to go into 2.6.28. It protects against a 
> recursion race that can happen when the scheduler is traced.

thanks, i've applied Lai's patch from email to tip/tracing/urgent.

	Ingo
