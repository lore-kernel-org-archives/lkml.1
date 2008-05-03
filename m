Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYECTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYECTRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYECTRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:17:38 -0400
Received: from www.tglx.de ([62.245.132.106]:40216 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYECTRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:17:37 -0400
Date: Sat, 3 May 2008 21:17:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Mikael Pettersson <mikpe@it.uu.se>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <481CB82D.60404@zytor.com>
Message-ID: <alpine.LFD.1.10.0805032115330.6003@apollo.tec.linutronix.de>
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <alpine.LFD.1.10.0805032017290.6003@apollo.tec.linutronix.de> <18460.46554.826031.184323@harpo.it.uu.se>
 <481CB82D.60404@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 May 2008, H. Peter Anvin wrote:

> Mikael Pettersson wrote:
> > 
> > I also noticed that jamal's /proc/cpuinfo contains
> > > cpu MHz         : 1063.771
> > which is either wrong or indicates serious overclocking.
> > The PIIs maxed out at about 400/450MHz.
> > 
> 
> It's worse than that... it's claiming to be a *Klamath*, which topped out at
> 300 MHz.

This might also be caused by a calibration error. We've seen enough of
them already.

Thanks,
	tglx

