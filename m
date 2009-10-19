Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZJSLXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZJSLXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbZJSLXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:23:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbZJSLXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:23:08 -0400
Date: Mon, 19 Oct 2009 13:23:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf stat: add branch performance counters to default
Message-ID: <20091019112302.GB12829@elte.hu>
References: <4ADC3975.8050109@klingt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADC3975.8050109@klingt.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Blechmann <tim@klingt.org> wrote:

> not sure, whether there is any reason, why the branch performance 
> counters are not enabled by default. personally, i would find it quite 
> useful, though

yeah, i find it useful too. The main reason is that most of the systems 
out there have like 2 freely defined events. Only Nehalem and i think 
Power7 has more.

OTOH ... maybe we should just do it, as most measurement and tuning is 
done on modern hardware. I'll try your patch in the perf tree - if too 
many people complain we will undo it.

	Ingo
