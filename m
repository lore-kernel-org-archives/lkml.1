Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbXFDRy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbXFDRy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXFDRyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:54:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbXFDRyt (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:54:49 -0400
Date: Mon, 4 Jun 2007 19:54:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Linux-kernel@vger.kernel.org
Subject: Re: Interesting interaction between lguest and CFS
Message-ID: <20070604175436.GC30274@elte.hu>
References: <20070604173710.GR11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604173710.GR11166@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> With 2.6.22-rc3-mm1, I've got a long-running video transcoding going 
> on. In other windows, I'm compiling, reading email, etc. with no 
> noticeable problems.
> 
> If I fire up lguest and leave it sitting at a shell prompt for a 
> couple moments, when I return to type something at the prompt, it can 
> take 2-3 seconds for my input to echo. Once it starts responding, 
> typing latency disappears. Suspend the other app and the latency 
> disappears.
> 
> The system isn't swapping and has basically no I/O load.

could you send me the /proc/PID/sched file of that task which shows this 
2-3 seconds delay? (if it's a shell and a graphical terminal then please 
send the sched-debug file of both.) I suspect the latency goes away if 
you strace -f the shell task(s)? If not then please send the strace 
output too.

	Ingo
