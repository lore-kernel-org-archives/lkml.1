Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYHSAPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYHSAPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbYHSAPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:15:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYHSAPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:15:00 -0400
Date: Tue, 19 Aug 2008 02:14:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: early_printk.c trivial sparse fixes
Message-ID: <20080819001433.GC9914@elte.hu>
References: <1219103789.17033.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219103789.17033.0.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> arch/x86/kernel/early_printk.c:404:13: warning: incorrect type in assignment (different base types)
> arch/x86/kernel/early_printk.c:404:13:    expected restricted __le16 [assigned] [usertype] wValue
> arch/x86/kernel/early_printk.c:404:13:    got int [signed] value
> arch/x86/kernel/early_printk.c:405:13: warning: incorrect type in assignment (different base types)
> arch/x86/kernel/early_printk.c:405:13:    expected restricted __le16 [assigned] [usertype] wIndex
> arch/x86/kernel/early_printk.c:405:13:    got int [signed] index
> arch/x86/kernel/early_printk.c:406:14: warning: incorrect type in assignment (different base types)
> arch/x86/kernel/early_printk.c:406:14:    expected restricted __le16 [assigned] [usertype] wLength
> arch/x86/kernel/early_printk.c:406:14:    got int [signed] size
> arch/x86/kernel/early_printk.c:845:16: warning: Using plain integer as NULL pointer
> arch/x86/kernel/early_printk.c:992:13: warning: symbol 'enable_debug_console' was not declared. Should it be static?
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

applied to tip/x86/early-printk - thanks Harvey!

	Ingo
