Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbXL3PKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbXL3PKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 10:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXL3PKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 10:10:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXL3PKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 10:10:01 -0500
Date: Sun, 30 Dec 2007 16:09:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify arch/x86/lib/Makefile(s)
Message-ID: <20071230150936.GW16946@elte.hu>
References: <20071230140835.GB13990@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230140835.GB13990@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> Trivial unification of Makefiles for the
> x86 specific library part.

thanks, applied to x86.git.

> Linking order is slightly modified but should be harmless.

the link order in this code is indeed expected to be harmless. (unlike 
the Makefile_64 link order changes, which contain lots of init sections 
with implicit call ordering - which can easily lead to subtle bugs.)

	Ingo
