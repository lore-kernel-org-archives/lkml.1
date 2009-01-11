Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZAKBso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZAKBso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZAKBsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:48:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60816 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZAKBsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:48:35 -0500
Date: Sun, 11 Jan 2009 02:48:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/9] Performance counters for POWER
Message-ID: <20090111014825.GO12885@elte.hu>
References: <18791.10652.298501.863657@cargo.ozlabs.ibm.com> <20090109134727.GA902@elte.hu> <18791.57319.639438.433546@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18791.57319.639438.433546@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > Do timec.c and kerneltop.c work fine for you by any chance? If yes, could 
> > you send us some sample output that you get with them on your power 
> > testbox(es)?
> 
> timec.c works with some minor modifications.  I'll post my version in a 
> separate message.  The main difference is that syscall() on powerpc 
> returns -1 on error and sets errno, rather than returning a negative 
> error number.  I also added a way to specify raw events.

thanks - i've picked up your version and uploaded it to:

   http://redhat.com/~mingo/perfcounters/timec.c

	Ingo
