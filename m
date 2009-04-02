Return-Path: <linux-kernel-owner+w=401wt.eu-S1757007AbZDBLn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbZDBLn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZDBLnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:43:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbZDBLnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:43:46 -0400
Date: Thu, 2 Apr 2009 13:43:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf_counter: move the event overflow output bits
	to record_type
Message-ID: <20090402114330.GA24618@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.151921176@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402091319.151921176@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> -	PERF_EVENT_OVERFLOW	= 1UL << 31,
> +	PERF_EVENT_COUNTER_OVERFLOW	= 1UL << 31,

>  	header.type = PERF_EVENT_OVERFLOW;

i fixed the obvious sed failure there :)

	Ingo
