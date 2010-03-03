Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0CCRkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:40:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0CCRj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:39:59 -0500
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.375353163@chello.nl>
	 <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 18:39:55 +0100
Message-ID: <1267637995.25158.96.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 09:30 -0800, Stephane Eranian wrote:
> This assumes struct pt_regs is somehow exported to userland.
> Is that the case?

I seems to have understood they were, and asm/ptrace.h seems to agree
with that, it has !__KERNEL__ definitions for struct pt_regs.

> I would clearly spell out that the REGS are the interrupted REGS,
> not the overflow REGS. Maybe PERF_SAMPLE_IREGS. 

They can be both, for PEBS they are the overflow trap (until PEBS does
fault) regs.

