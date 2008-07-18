Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYGRNgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYGRNgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYGRNgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:36:01 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:41618 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbYGRNgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:36:00 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com, arjan <arjan@infradead.org>, sandmann@daimi.au.dk,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs 	(part1: use kprobe symbol_name/offset instead of address)
From: Andi Kleen <andi@firstfloor.org>
References: <1216146802.3312.95.camel@localhost.localdomain>
	<87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins>
	<y0m7ibjjqg4.fsf@ton.toronto.redhat.com>
	<1216386627.28405.42.camel@twins>
Date: Fri, 18 Jul 2008 15:35:29 +0200
In-Reply-To: <1216386627.28405.42.camel@twins> (Peter Zijlstra's message of "Fri, 18 Jul 2008 15:10:27 +0200")
Message-ID: <871w1r9uxq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2008 13:35:27.0579 (UTC) FILETIME=[23C712B0:01C8E8DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> I think sysprof (kernel/trace/trace_sysprof.c) already does user-space
> stack unwinding. So pushing that capability further up the chain when a
> second user (stap) comes along makes perfect sense.

oprofile call trace profiling also does it.

-Andi
