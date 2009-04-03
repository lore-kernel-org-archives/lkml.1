Return-Path: <linux-kernel-owner+w=401wt.eu-S936565AbZDCXDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936565AbZDCXDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 19:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZDCXDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 19:03:41 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:48539 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZDCXDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:03:40 -0400
Subject: Re: [Announce] 2.6.29.1-rt4
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: nando@ccrma.Stanford.EDU, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Will Schmidt <will_schmidt@vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 16:04:12 -0700
Message-Id: <1238799852.3871.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 19:21 +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
>   
> 	- rebased to 2.6.29.1
> 
> 	- powerpc64 tlb rework fix by Peter

Thanks for cc'ing me...

Just a heads up. I'm still having shutdown/suspend problems with this
release as before (I had not reported the suspend problem, I think -
machine hangs and has to be power cycled). Booting with "noreplace-smp"
fixes both. Is this something I could disable through configuration
options?

I was also seeing a hard hang when running a java program (with the
Fedora 10 open source java) - the swingosc gui component of
SuperCollider 3 (a computer music synthesis program). Impossible to know
what had failed, machine completely catatonic and nothing left on the
logs. 

I managed to start the same program _once_ (have not tested again) with
2.6.29.1/rt4 + some patches & config from fc10' koji 2.6.29.1-15. The
mouse seemed to pause a couple of times and then I killed the program.
Restarting it again was successful. Sorry to not have more hard info...

-- Fernando


