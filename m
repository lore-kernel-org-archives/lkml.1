Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYCZKZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYCZKZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYCZKZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:25:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbYCZKZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:25:31 -0400
Date: Wed, 26 Mar 2008 11:25:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
Message-ID: <20080326102514.GB17176@elte.hu>
References: <20080325084457.GA32103@elte.hu> <20080325.024204.175042056.davem@davemloft.net> <20080325131708.GB9612@elte.hu> <20080325.160916.182495221.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325.160916.182495221.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 25 Mar 2008 14:17:08 +0100
> 
> > There can be fluctuations and artifacts, and obviously this is just 
> > another (arbitrary) static metric that has no forced relationship with 
> > real code quality - but in my experience it's surprisingly close to 
> > reality - closer than any other code metric i've seen.
> 
> And yet you used it to claim that the sparc64 port is an 
> unmaintainable pile of poo.

i did not claim that at all, the checkpatch average of sparc64 is pretty 
good:

                           errors   lines of code   errors/KLOC
   arch/sparc64/             1457           49785          29.2

Sparc64 is one of the cleanest architectures, in terms of average 
checkpatch.pl code-quality.

the list i generated is the '20 worst files' (out of 90 sparc64 files) 
those are the files in need of cleanups (according to that metric) - and 
a quick manual glance confirmed that impression.

Or is it your position that every single file in sparc64 is squeaky 
clean and that each of the 1457 cleanliness problems that checkpatch.pl 
reported there is bogus?

	Ingo
