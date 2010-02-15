Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0BOGD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:03:58 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:39023 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0BOGD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:03:56 -0500
Date: Mon, 15 Feb 2010 08:03:52 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33-rc8 regression: irq11: nobody cared, during yenta
 registration
In-Reply-To: <201002150018.21417.rjw@sisk.pl>
Message-ID: <alpine.SOC.1.00.1002150743540.21314@math.ut.ee>
References: <alpine.SOC.1.00.1002141720120.679@math.ut.ee> <201002150018.21417.rjw@sisk.pl>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Just tried 2.6.33-rcx8 on my laptop (Thinkpad X20 in a dock) that was 
> > last running 2.6.33-rc5 without problems. Gor irq11: nobody carec like 
> > below. Seems to be repeatabale. lspci also below.
> 
> I have created the Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15307
> for your report.
> 
> Peter, Ingo, did we do anything to the interrupt handling between .33-rc5 and .33-rc8?

I just retested it and the problem appears even in -rc5 (missed it 
before). Come to think of it, I only tested -rc5 out of dock before.

With dock, the problem is there in 2.6.33-rc4-00399-g24bc734.

Without dock, even -rc8 is OK, so it only happens docked.

Will try to bisect but this takes time because I'm rarely near that 
computer.

-- 
Meelis Roos (mroos@linux.ee)
