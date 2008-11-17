Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYKQLIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYKQLIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 06:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYKQLIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 06:08:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbYKQLIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 06:08:41 -0500
Date: Mon, 17 Nov 2008 12:08:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: rostedt@goodmis.org, akpm@linux-foundation.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix writing to trace/trace_options
Message-ID: <20081117110824.GM28786@elte.hu>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:

> writing to trace/trace_options use the index of the array
> to find the value of the flag. With branch tracer flag
> defined conditionally, this breaks writing to trace_options
> with branch tracer disabled.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> ---
>  kernel/trace/trace.c |    2 --
>  kernel/trace/trace.h |    2 --
>  2 files changed, 0 insertions(+), 4 deletions(-)

applied to tip/tracing/branch-tracer, thanks Aneesh!

	Ingo
