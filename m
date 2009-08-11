Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZHKMFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZHKMFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZHKMFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:05:53 -0400
Received: from viefep33-int.chello.at ([62.179.121.51]:38375 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZHKMF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:05:29 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch] cache-miss and cache-refs events on P6-mobile CPUs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090811093405.GA13004@elte.hu>
References: <87k51cgdt8.fsf@basil.nowhere.org>
	 <20090810122731.GA5863@sig21.net> <20090810123228.GD6838@basil.fritz.box>
	 <20090810125651.GB6082@sig21.net> <20090810132923.GA4418@elte.hu>
	 <20090810192658.GA15513@sig21.net> <20090810201406.GA6961@elte.hu>
	 <20090810203706.GA17338@sig21.net> <20090810213133.GB16944@elte.hu>
	 <20090810221307.GA19236@sig21.net>  <20090811093405.GA13004@elte.hu>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 11:39:39 +0200
Message-Id: <1249983579.17467.156.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 11:34 +0200, Ingo Molnar wrote:

> @@ -116,8 +116,8 @@ static const u64 p6_perfmon_event_map[] 
>  {
>    [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
>    [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
> -  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0000,
> -  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0000,
> +  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
> +  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,

2e is total numer of L2 events,

0f is all mesi states
01 is invalid states

Yes they are numbers, but no they are not full cache refs and misses.


I don't think this is a good patch.

