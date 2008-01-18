Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYARJHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYARJHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYARJHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:07:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbYARJHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:07:21 -0500
Date: Fri, 18 Jan 2008 10:07:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Rename stack_pointer to kernel_trap_sp
Message-ID: <20080118090707.GC24337@elte.hu>
References: <1200611078.5724.46.camel@brick> <478FDE76.3070309@zytor.com> <1200612389.5724.63.camel@brick> <478FF9F3.9030604@zytor.com> <1200618952.5724.85.camel@brick> <20080118013712.4090526FA0B@magilla.localdomain> <479002B6.9030607@zytor.com> <1200622862.5724.106.camel@brick> <47901E89.4060001@zytor.com> <1200630529.5724.116.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200630529.5724.116.camel@brick>
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

>  	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
> -	unsigned long stack = stack_pointer(regs);
> +	unsigned long stack = kernel_trap_sp(regs);

thanks, applied.

	Ingo
