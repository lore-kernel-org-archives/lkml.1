Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbYECS7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbYECS7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYECS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:59:36 -0400
Received: from aun.it.uu.se ([130.238.12.36]:54634 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYECS7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:59:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18460.46554.826031.184323@harpo.it.uu.se>
Date: Sat, 3 May 2008 20:58:34 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, jamal <hadi@cyberus.ca>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <alpine.LFD.1.10.0805032017290.6003@apollo.tec.linutronix.de>
References: <1209810775.6972.37.camel@localhost>
	<alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de>
	<481CA40A.7040906@zytor.com>
	<alpine.LFD.1.10.0805032017290.6003@apollo.tec.linutronix.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner writes:
 > On Sat, 3 May 2008, H. Peter Anvin wrote:
 > 
 > > Thomas Gleixner wrote:
 > > > 
 > > > Jan, are you sure that P3 knows the P6 NOPs ? AFAICT its P4, but I
 > > > have to dig up the manuals.
 > > > 
 > > 
 > > Pentium III is the P6 core, so it will.
 > > 
 > > Intel explicitly documents "all processors with family 6 or F."
 > 
 > Yeah, I looked up myself and noticed that I confused those stupid
 > numbers again.
 > 
 > Nevertheless reality seems to tell a different story :)

I've tested the "0f 1f 00" 3-byte NOP on two PIIs,
a Klamath (family 6 model 3 stepping 4) and a Deschutes
(family 6 model 5 stepping 0), and it worked fine on both.

Are you absolutely sure it's this 3-byte NOP that oopses?

I also noticed that jamal's /proc/cpuinfo contains
> cpu MHz         : 1063.771
which is either wrong or indicates serious overclocking.
The PIIs maxed out at about 400/450MHz.

/Mikael
