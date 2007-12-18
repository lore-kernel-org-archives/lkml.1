Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbXLRR60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbXLRR60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXLRR6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:58:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbXLRR6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:58:18 -0500
Date: Tue, 18 Dec 2007 18:57:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: unify extable_{32|64}.c
Message-ID: <20071218175753.GA10584@elte.hu>
References: <1197974193.7734.18.camel@brick> <476806AF.5030405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476806AF.5030405@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Harvey,
> 
> Harvey Harrison wrote:
> > Introduce fixup_exception() on X86_64 and use it in kprobes to
> > eliminate an #ifdef.
> > 
> > Only X86_64 needs search_extable() due to a stepping bug.
> 
> It's a good work!
> If you can work on it, please add a prototype declaration of
> fixup_exception() in asm-x86/uaccess_64.h too.

FYI, i've already added this to x86.git, it was needed for 64-bit to 
build fine.

	Ingo
