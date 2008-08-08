Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYHHGoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYHHGoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYHHGoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:44:03 -0400
Received: from ozlabs.org ([203.10.76.45]:58096 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYHHGoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:44:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] ftrace: enable mcount recording for modules
Date: Fri, 8 Aug 2008 16:43:51 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
References: <20080807182013.984175558@goodmis.org> <20080807182117.136812885@goodmis.org>
In-Reply-To: <20080807182117.136812885@goodmis.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200808081643.51942.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008 04:20:16 Steven Rostedt wrote:
> This patch enables the loading of the __mcount_section of modules and
> changing all the callers of mcount into nops.
>
> The modification is done before the init_module function is called, so
> again, we do not need to use kstop_machine to make these changes.

Importantly, before parameter parsing too (which can use module functions 
before the module's init()).

Cheers,
Rusty.
