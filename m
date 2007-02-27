Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524AbXB0KCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbXB0KCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXB0KCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:02:31 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:46966 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXB0KCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:02:31 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mbligh@google.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070227062913.GC1259@elte.hu>
References: <20061126231833.GA22241@Krystal>
	 <1164585589.16871.52.camel@localhost.localdomain>
	 <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com>
	 <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com>
	 <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com>
	 <20070227035456.GA15444@Krystal>
	 <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 01:59:43 -0800
Message-Id: <1172570383.5517.217.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 07:29 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > The pit clocksource could be dropped pretty easy with my clocksource 
> > update patches, which I'm still working on but you could easily drop 
> > clock sources that aren't atomic like the pit .. Also the pit is 
> > generally undesirable, so it's not going to be missed.
> 
> that's totally unacceptable, and i'm amazed you are even suggesting it - 
> often the PIT ends up being the most reliable hardware clock in a PC. 
> Btw., what's wrong with the spinlock that is protecting PIT access? It 
> expresses the non-atomic property of the PIT just fine.

Just considering the rating is lower than the acpi_pm (and the TSC), and
it's not even considered on SMP systems is enough for me .. It's just a
problematic clock.. 

Again, I'm not suggesting we drop it all the time, just for a special
case when Mathieu needs it dropped.

Daniel

