Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbXEUIzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbXEUIzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 04:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbXEUIzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 04:55:25 -0400
Received: from www.osadl.org ([213.239.205.134]:33227 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760402AbXEUIzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 04:55:22 -0400
Subject: Re: [BUG] local_softirq_pending storm
From: Thomas Gleixner <tglx@linutronix.de>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <200705211152.08518.kernel@prachanda.hub>
References: <200705091942.22920.kernel@prachanda.hub>
	 <200705200253.44992.kernel@prachanda.hub> <1179697388.6570.26.camel@chaos>
	 <200705211152.08518.kernel@prachanda.hub>
Content-Type: text/plain
Date: Mon, 21 May 2007 11:01:57 +0200
Message-Id: <1179738117.6570.37.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 11:52 +0530, Anant Nitya wrote:
> > You should find something like:
> >
> > (         swapper-0    |#0): new 67173 us user-latency.
> >
> > along with the familiar "NOHZ ......" message in your log file.
> >
> > Once that happened please do:
> >
> > $ cat /proc/latency_trace >trace.txt
> >
> > compress it and send it to me along with the full dmesg output or put
> > both up to some place, where I can download it.
> Hi Thomas
> 
> Here are the links...
> http://cybertek.info/taitai/dmesg-2.6.22.rc2.hrt2-1.SMP.DN.LINUX.txt
> http://cybertek.info/taitai/trace.txt.bz2

Thanks. Sorry, I need more info. I uploaded a new tracer.diff to 

http://www.tglx.de/private/tglx/ht-debug/tracer.diff

Can you please revert the first one and retest with the new one ?

Thanks,

	tglx



