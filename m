Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYKLJSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYKLJSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYKLJR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:17:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55907 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYKLJR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:17:56 -0500
Date: Wed, 12 Nov 2008 10:17:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/fastboot: Move boot tracer structs and
	funcs into their own header.
Message-ID: <20081112091745.GD4748@elte.hu>
References: <491A056B.2010500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491A056B.2010500@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: Cleanups on the boot tracer and ftrace
> 
> This patch bring some cleanups about the boot tracer headers. The 
> functions and structures of this tracer have nothing related to 
> ftrace and should have so their own header file.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/linux/ftrace.h |   41 -----------------------------------------
>  include/trace/boot.h   |   43 +++++++++++++++++++++++++++++++++++++++++++
>  init/main.c            |    1 +
>  kernel/trace/trace.h   |    1 +
>  4 files changed, 45 insertions(+), 41 deletions(-)

applied to tip/tracing/fastboot, thanks Frederic!

	Ingo
