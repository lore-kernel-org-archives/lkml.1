Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYBGMOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYBGMOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYBGMOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:14:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45861 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbYBGMOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:14:01 -0500
Date: Thu, 7 Feb 2008 13:13:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Jan Kiszka <jan.kiszka@web.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] KGDB: Major refactoring
Message-ID: <20080207121343.GA5697@elte.hu>
References: <47A8F275.9090901@web.de> <20080207001336.GA22986@elte.hu> <47AA5165.4070201@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AA5165.4070201@windriver.com>
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


* Jason Wessel <jason.wessel@windriver.com> wrote:

> > Could you try something else too perhaps, which would be way useful 
> > for me: to add a sysctl flag (or something like that) to change 
> > kgdboc to accept a Ctrl-C and break into kgdb mode? [this means a 
> > simple Ctrl-C on a kgdboc line would break into KGDB as well - but 
> > that would be an acceptable price.] Right now kgdboc just hangs when 
> > gdb attaches - i have to generate a SysRq sequence via a terminal 
> > emulator to break it into KGDB mode.
> 
> FYI, even if you were to hack in a control-c vs sysrq, gdb will still 
> hang on connect because it does not issue a break of any kind when it 
> connects.  It assumes the connection is in a usable state.

sigh. That's quite a usability barrier IMHO.

> The proxy spliter automatically sends the break (or in the current 
> case the sysrq g)

any link to the proxy splitter? Googling for "kgdb proxy splitter" did 
not yield anything obviously on-topic.

	Ingo
