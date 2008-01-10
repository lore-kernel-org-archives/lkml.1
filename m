Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYAJNdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYAJNdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYAJNdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:33:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbYAJNdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:33:07 -0500
Date: Thu, 10 Jan 2008 14:32:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>
Cc: Matthew <jackdachef@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of
	32bit applications(binaries) on 64bit system (Gentoo)
Message-ID: <20080110133252.GB5886@elte.hu>
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com> <e85b9d30801100443s50ab2b69wbf1a7b4dbd09f002@mail.gmail.com> <20080110124810.GA20579@elte.hu> <200801100808.42945.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801100808.42945.edt@aei.ca>
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


* Ed Tomlinson <edt@aei.ca> wrote:

> Matthew is not alone with this problem.  I have it too.  Its not new 
> here.  Its been happening as long as I have had gentoo amd64 
> installed.  It can be hard to reproduce but eventually, when 32 bit 
> apps are used, my box bricks.  There is nothing in the logs (nor on a 
> serial console) - the box just freezes.
> 
> My kernel is _not_ tainted. [...]

ok, good. A series of questions:

- can you reproduce it from the VGA console?

- if yes, does booting with "nmi_watchdog=2 idle=poll" give you a 
  working NMI watchdog? (working NMI watchdog means the NMI counts 
  increase for all cores in /proc/interrupts).

if still 'yes', then try to reproduce the hard hang on the VGA text 
console - do you perhaps get an NMI backtrace printed within 1-2 minutes 
after the hard hang happens? If yes then take a photo of that or write 
it down.

	Ingo
