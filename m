Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYAGNc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYAGNc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYAGNcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:32:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47461 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYAGNcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:32:48 -0500
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
From: Peter Zijlstra <peterz@infradead.org>
To: jplatte@naasa.net
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <200801071424.12448.lists@naasa.net>
References: <200801071151.11200.lists@naasa.net>
	 <20080107111930.GB29973@elte.hu>  <200801071424.12448.lists@naasa.net>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 14:32:37 +0100
Message-Id: <1199712757.7143.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 14:24 +0100, Joerg Platte wrote:

This is from: 2.6.24-rc7

> kernel: pdflush       D f41c2f14     0 18822      2
> kernel:        f673f000 00000046 00000286 f41c2f14 f5194ce0 00000286 00000286 f41c2f14 
> kernel:        00175279 f41c2f6c 00000000 c0271f6c f5ff363c f5ff3644 c0354a90 c0354a90 
> kernel:        00175279 c0123251 f5194b80 c03546c0 c0271f67 6c666470 00687375 00000000 
> kernel: Call Trace:
> kernel:  [<c0271f6c>] schedule_timeout+0x6e/0x8b
> kernel:  [<c0123251>] process_timeout+0x0/0x5
> kernel:  [<c0271f67>] schedule_timeout+0x69/0x8b
> kernel:  [<c027179a>] __sched_text_start+0x3a/0x70
> kernel:  [<c014d34b>] congestion_wait+0x4e/0x62
> kernel:  [<c012be2b>] autoremove_wake_function+0x0/0x33
> kernel:  [<c014971e>] pdflush+0x0/0x1bf
> kernel:  [<c01493c6>] wb_kupdate+0x8c/0xd1
> kernel:  [<c014971e>] pdflush+0x0/0x1bf
> kernel:  [<c0149839>] pdflush+0x11b/0x1bf
> kernel:  [<c014933a>] wb_kupdate+0x0/0xd1
> kernel:  [<c012bd71>] kthread+0x36/0x5d
> kernel:  [<c012bd3b>] kthread+0x0/0x5d
> kernel:  [<c010493b>] kernel_thread_helper+0x7/0x10
> kernel:  =======================

What filesystem are you using?

