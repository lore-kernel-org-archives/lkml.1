Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYBJVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYBJVOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYBJVOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:14:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53038 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYBJVOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:14:01 -0500
Date: Sun, 10 Feb 2008 22:13:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ray Lee <ray-lk@madrabbit.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@zip.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
Message-ID: <20080210211347.GB29507@elte.hu>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <20080210163603.GB28201@elte.hu> <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com> <47AF483E.10905@web.de> <alpine.LFD.1.00.0802101134470.2896@woody.linux-foundation.org> <47AF5D21.6010400@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AF5D21.6010400@web.de>
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


* Jan Kiszka <jan.kiszka@web.de> wrote:

> Maybe, maybe not. I followed the comment in the original code, saying 
> that we need word-wise access for I/O memory poking. Can I assume 
> across a all archs that __copy_to/from_user will not perform byte 
> accesses if count is 2, 4, or 8? I would be glad if we can kill other 
> couple of line.

those architectures should extend mm/maccess.c accordingly. It's now the 
collector point for "weird kernel-owned memory access functionality".

> Ingo, if you are close to an editor, please pick those up? Here are 
> some offline things cooking on my side...

yeah, fixed these in my tree.

	Ingo
