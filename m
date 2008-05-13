Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbYEMNxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbYEMNxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbYEMNxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:53:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50526 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263AbYEMNxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:53:13 -0400
Date: Tue, 13 May 2008 15:52:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: Pavel Roskin <proski@gnu.org>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace/sysprof: Don't trace the user stack if we are a
	kernel thread.
Message-ID: <20080513135259.GE5809@elte.hu>
References: <ye8tzh4dwul.fsf@camel09.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye8tzh4dwul.fsf@camel09.daimi.au.dk>
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


* Soeren Sandmann <sandmann@daimi.au.dk> wrote:

> Check that current->mm is non-NULL before attempting to trace the user 
> stack.
> 
> Also take depth of the kernel stack into account when comparing
> against sample_max_depth.

applied, thanks.

(Please also add a Signed-off-by patch to future patches.)

	Ingo
