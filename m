Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXLONMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXLONMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 08:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXLONMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 08:12:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37583 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbXLONMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 08:12:21 -0500
Date: Sat, 15 Dec 2007 14:12:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: FInal kprobes rollup patches
Message-ID: <20071215131204.GE9720@elte.hu>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu> <1197709442.898.97.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197709442.898.97.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> If you compare this memcpy from arch_prepare_kprobe in 32/64 bit I'm 
> almost sure the X86_32 version should be
> 
> ... + sizeof(kprobe_opcode_t)
> 
> not
> 
> ... * sizeof(kprobe_opcode_t)

good point. I've Cc:-ed the top authors of kprobes.c. Could anyone 
confirm (or deny) that Harvey found a real kprobes bug here?

	Ingo
