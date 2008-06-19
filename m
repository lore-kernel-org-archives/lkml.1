Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYFSM0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYFSM0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYFSMZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:25:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbYFSMZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:25:57 -0400
Date: Thu, 19 Jun 2008 14:25:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86-64: remove unnecessary ptregs call stubs
Message-ID: <20080619122538.GH7640@elte.hu>
References: <485910B3.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485910B3.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> A few of the ptregs call stubs are superfluous these days - the called 
> functions don't have a trailing 'struct pt_regs *' parameter anymore.

applied to tip/x86/cleanups - thanks Jan.

	Ingo
