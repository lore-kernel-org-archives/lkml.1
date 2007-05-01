Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbXEAQoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbXEAQoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXEAQoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:44:12 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:26661 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbXEAQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:44:10 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both
	of	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Daniel Walker <dwalker@mvista.com>
To: Mark Lord <lkml@rtr.ca>
Cc: tglx@linutronix.de, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <46376B63.9080808@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca>  <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com>  <463683A6.4010505@rtr.ca>
	 <1178026458.5791.305.camel@localhost.localdomain> <4637419D.8010303@rtr.ca>
			 <463741F1.7050706@rtr.ca>
	 <1178027285.5791.307.camel@localhost.localdomain> <46374B1D.6050509@rtr.ca>
	 <1178033061.5791.314.camel@localhost.localdomain> <46376B63.9080808@rtr.ca>
Content-Type: text/plain
Date: Tue, 01 May 2007 09:42:30 -0700
Message-Id: <1178037750.12796.321.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 12:31 -0400, Mark Lord wrote:
> Thomas Gleixner wrote:
> > 
> > I meant disable HPET via: hpet=disable on the commandline 
> > 
> >> Screenshots for that are available here:   http://rtr.ca/hrtimers/
> 
> hpet=disable fails, without the "switched to high resolution timer" message(s).
> New snapshot of it now at the link above.
> 
> I also applied Tejun's early libata/SCSI race fix,
> and that made no difference either.
> 
> Cheers

Have you tried !SMP or adding the boot arg "maxcpus=1" .. Hadn't seen
that in prior emails.

Daniel

