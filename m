Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXEBHo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXEBHo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXEBHo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:44:56 -0400
Received: from www.osadl.org ([213.239.205.134]:57344 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752145AbXEBHoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:44:55 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both
	of	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mark Lord <lkml@rtr.ca>
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <46377055.2060605@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca>
	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>
			 <463741F1.7050706@rtr.ca>
	 <1178027285.5791.307.camel@localhost.localdomain> <46374B1D.6050509@rtr.ca>
	 <1178035058.5791.333.camel@localhost.localdomain> <46377055.2060605@rtr.ca>
Content-Type: text/plain
Date: Wed, 02 May 2007 09:47:15 +0200
Message-Id: <1178092035.5791.349.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Tue, 2007-05-01 at 12:52 -0400, Mark Lord wrote:
> Done, and done.
> And I managed to capture more of the boot messages, too.
> This new capture is in the "sequence" subdir at the previous link.

thanks. Can you apply this patch please:
http://lkml.org/lkml/2007/4/13/190

It somehow did not make it into 2.6.21.

	tglx


