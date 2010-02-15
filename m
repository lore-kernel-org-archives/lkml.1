Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0BOTsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:48:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab0BOTsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:48:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: 2.6.33-rc8 regression: irq11: nobody cared, during yenta registration
Date: Mon, 15 Feb 2010 20:48:59 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
References: <alpine.SOC.1.00.1002141720120.679@math.ut.ee> <201002150018.21417.rjw@sisk.pl> <alpine.SOC.1.00.1002150743540.21314@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1002150743540.21314@math.ut.ee>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002152048.59832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 February 2010, Meelis Roos wrote:
> > > Just tried 2.6.33-rcx8 on my laptop (Thinkpad X20 in a dock) that was 
> > > last running 2.6.33-rc5 without problems. Gor irq11: nobody carec like 
> > > below. Seems to be repeatabale. lspci also below.
> > 
> > I have created the Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15307
> > for your report.
> > 
> > Peter, Ingo, did we do anything to the interrupt handling between .33-rc5 and .33-rc8?
> 
> I just retested it and the problem appears even in -rc5 (missed it 
> before). Come to think of it, I only tested -rc5 out of dock before.
> 
> With dock, the problem is there in 2.6.33-rc4-00399-g24bc734.
> 
> Without dock, even -rc8 is OK, so it only happens docked.
> 
> Will try to bisect but this takes time because I'm rarely near that 
> computer.

OK, thanks for the update.

Rafael
