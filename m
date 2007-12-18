Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbXLRKy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbXLRKy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXLRKyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:54:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42457 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbXLRKyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:54:17 -0500
Date: Tue, 18 Dec 2007 11:53:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] x86: unify extable_{32|64}.c
Message-ID: <20071218105357.GD29466@elte.hu>
References: <1197974193.7734.18.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197974193.7734.18.camel@brick>
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

> Introduce fixup_exception() on X86_64 and use it in kprobes to 
> eliminate an #ifdef.
> 
> Only X86_64 needs search_extable() due to a stepping bug.

thanks, applied.

	Ingo
