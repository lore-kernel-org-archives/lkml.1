Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbXE1PdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbXE1PdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbXE1Pc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:32:56 -0400
Received: from www.osadl.org ([213.239.205.134]:57827 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750900AbXE1Pcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:32:54 -0400
Subject: Re: b44: regression in 2.6.22 (resend)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200705281714.25841.mb@bu3sch.de>
References: <20070525172431.60affaca@freepuppy>
	 <200705281216.51690.mb@bu3sch.de> <200705281609.49859.maxi@daemonizer.de>
	 <200705281714.25841.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 28 May 2007 17:32:51 +0200
Message-Id: <1180366371.4952.5.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-28 at 17:14 +0200, Michael Buesch wrote:
> > The -oldconfig1 is the kernel that had no problems and the other shows the b44 
> > problem. So if High Resolution Timer Support is disabled everything works 
> > fine and if I enable it the problems do appear again.
> > 
> > I didn't test this on my 2.6.22-rc3 kernel yet, but I guess disabling High 
> > Resolution Timer Support will also solve the problem there.
> > 
> > The older kernels I tried also work perfectly fine and they didn't have the 
> > High Resolution Timer Support yet.
> 
> So, that's interesting, indeed.
> Any idea what's going on, someone? Thomas?

Not off the top of my head.

Maximilian, does the kernel work otherwise (I mean aside of the b44
driver) ? 

Can you please keep CONFIG_HIGH_RES_TIMERS and CONFIG_NOHZ and try the
following combinations on the kernel command line:

1) highres=off nohz=off (should be the same as your working config)
2) highres=off
3) nohz=off

Michael, is anything in the b44 driver timer driven ?

Thanks,

	tglx


