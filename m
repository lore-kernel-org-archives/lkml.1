Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZFASWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZFASWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZFASWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:22:13 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:52025 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbZFASWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:22:12 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Tidy up style details
Date: Mon, 1 Jun 2009 20:22:10 +0200
User-Agent: KMail/1.9.9
Cc: acme@redhat.com, paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
References: <tip-22a4f650d686eeaac3629dae1c4294381485efdf@git.kernel.org>
In-reply-To: <tip-22a4f650d686eeaac3629dae1c4294381485efdf@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012022.13351.elendil@planet.nl>
X-OriginalArrivalTime: 01 Jun 2009 18:22:13.0755 (UTC) FILETIME=[E2D1ACB0:01C9E2E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Ingo Molnar wrote:
> @@ -3526,7 +3529,7 @@ inherit_counter(struct perf_counter *parent_counter,
>	/*
>	* Make the child state follow the state of the parent counter,
>	* not its hw_event.disabled bit.  We hold the parent's mutex,
> -	* so we won't race with perf_counter_{en,dis}able_family.
> +	* so we won't race with perf_counter_{en, dis}able_family.
> 	*/
> 	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
> 	child_counter->state = PERF_COUNTER_STATE_INACTIVE;

I wouldn't call this an improvement TBH.

perf_counter_{en,dis}able_family expands to
   perf_counter_enable_family + perf_counter_disable_family

while perf_counter_{en, dis}able_family expands to
   perf_counter_enable_family + "perf_counter_ disable_family"

Cheers,
FJP
