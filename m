Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbXERQpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbXERQpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbXERQpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:45:42 -0400
Received: from www.osadl.org ([213.239.205.134]:45692 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754665AbXERQpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:45:41 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Thomas Gleixner <tglx@linutronix.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Sealey <matt@genesi-usa.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Robert Schwebel <r.schwebel@pengutronix.de>
In-Reply-To: <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	 <464C99FF.8080404@ru.mvista.com>
	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	 <464C9E67.2020909@ru.mvista.com>
	 <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org>
	 <464CA222.8000407@ru.mvista.com> <464D9E7E.3090605@genesi-usa.com>
	 <464DADFC.3080802@ru.mvista.com>  <464DB800.40702@genesi-usa.com>
	 <1179499713.12981.75.camel@chaos>
	 <32E780BE-58B7-4303-AA49-1852C4C7EB50@kernel.crashing.org>
Content-Type: text/plain
Date: Fri, 18 May 2007 18:50:59 +0200
Message-Id: <1179507059.12981.81.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 11:31 -0500, Kumar Gala wrote:
> I asked this earlier, but figured you might have a better insight.   
> Is their value in having 'drivers' for more than one clock source?   
> I'd say most (of not all) the PPC SoCs have timers on the system side  
> that we could provide drivers for, I'm just not sure if that does  
> anything for anyone.

Not necessarily for the tick/highres stuff, but clock events allows
other users as well to utilize such facilities. We have no users yet,
but there are drivers, which utilize special timer hardware with nice
#ifdeffery to allow the driver to be shared. This might be a useful
thing for such stuff.

	tglx


