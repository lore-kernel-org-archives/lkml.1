Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbYA1LEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbYA1LEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYA1LDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:03:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46451 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbYA1LDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:03:54 -0500
Date: Mon, 28 Jan 2008 12:03:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2 1/9] x86: Unify whitespace and comments in
	arch/x86/boot/compressed/vmlinux_??.lds
Message-ID: <20080128110333.GD32342@elte.hu>
References: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk> <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0284]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


thanks Ian, i've picked up your series into x86.git.

one small nit - when doing cleanups i've been consistently using this 
formatting for comments:

       /*
        * Be careful parts of head_32.S assume startup_32 is at
        * address 0.
        */

instead of:

       /* Be careful parts of head_32.S assume startup_32 is at
        * address 0.
        */

(this is just personal preference, both forms are CodingStyle conform.  
I like the former a bit more because it visually separates comments from 
previous lines of code more. [and comments have rarely any relationship 
to previous code - they apply to the following code lines.] Anyway, no 
need to resend the series - just please keep this in mind for future 
cleanups.)

	Ingo
