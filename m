Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYCKOAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYCKOAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYCKOAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:00:38 -0400
Received: from www.tglx.de ([62.245.132.106]:57777 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbYCKOAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:00:37 -0400
Date: Tue, 11 Mar 2008 14:59:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Treason uncloaked spams syslog with latest git
In-Reply-To: <Pine.LNX.4.64.0803111138360.5423@kivilampi-30.cs.helsinki.fi>
Message-ID: <alpine.LFD.1.00.0803111440040.3781@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0803061140380.3099@apollo.tec.linutronix.de> <20080306153129.e247cd1a.akpm@linux-foundation.org> <Pine.LNX.4.64.0803071547370.5423@kivilampi-30.cs.helsinki.fi> <alpine.LFD.1.00.0803072050410.3099@apollo.tec.linutronix.de>
 <alpine.LFD.1.00.0803102046420.3781@apollo.tec.linutronix.de> <Pine.LNX.4.64.0803111138360.5423@kivilampi-30.cs.helsinki.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-298178265-1205243994=:3781"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-298178265-1205243994=:3781
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 11 Mar 2008, Ilpo Järvinen wrote:
> > http://www.tglx.de/~tglx/treason.cap
> > 
> > That's on -rc5
> 
> Thanks, I think I found the reason. Does the patch below fix it...

Yes, it does.

> message suggests, we had just sent something past it without
> a permission to do so).
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

Tested-by: Thomas Gleixner <tglx@linutronix.de>

Thanks,

	tglx
--8323328-298178265-1205243994=:3781--
