Return-Path: <linux-kernel-owner+w=401wt.eu-S1030581AbXB0ItE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581AbXB0ItE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXB0ItB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:49:01 -0500
Received: from www.osadl.org ([213.239.205.134]:54285 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030581AbXB0Is7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:48:59 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
In-Reply-To: <20070227073815.GA25894@Krystal>
References: <1164585589.16871.52.camel@localhost.localdomain>
	 <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com>
	 <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com>
	 <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com>
	 <20070227035456.GA15444@Krystal>
	 <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu>
	 <20070227073815.GA25894@Krystal>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 09:48:41 +0100
Message-Id: <1172566121.3656.2.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 02:38 -0500, Mathieu Desnoyers wrote:
> > > The pit clocksource could be dropped pretty easy with my clocksource 
> > > update patches, which I'm still working on but you could easily drop 
> > > clock sources that aren't atomic like the pit .. Also the pit is 
> > > generally undesirable, so it's not going to be missed.
> > 
> > that's totally unacceptable, and i'm amazed you are even suggesting it - 
> > often the PIT ends up being the most reliable hardware clock in a PC. 
> > Btw., what's wrong with the spinlock that is protecting PIT access? It 
> > expresses the non-atomic property of the PIT just fine.
> > 
> 
> I am concerned about the automatic fallback to the PIT when no other
> clock source is available. 

And what are you going to use then ? Just kill the box, when nothing
else than PIT is there ? 

	tglx


