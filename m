Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZHTP3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZHTP3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZHTP3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:29:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33845 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZHTP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:29:40 -0400
Date: Thu, 20 Aug 2009 20:59:31 +0530
From: Dinakar Guniguntala <dino@in.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc6-rt5
Message-ID: <20090820152931.GA5731@in.ibm.com>
Reply-To: dino@in.ibm.com
References: <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain> <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain> <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain> <1f1b08da0908191919x77c8e9edu9f31a9a56ba41ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f1b08da0908191919x77c8e9edu9f31a9a56ba41ee@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 07:19:02PM -0700, john stultz wrote:
> On Wed, Aug 19, 2009 at 2:48 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> 
> Hey Thomas, Peter, Ingo,
>     I'm still seeing the odd SMP scheduler behavior (where all the
> processes line up on a single cpu) with -rt5. This can be easily
> reproduced with a "make -j8 bzImage".  I'm I the only one seeing this?

I am seeing it with 2.6.31-rcX-rtY kernels on both a 8 CPU AMD/Intel box
Specjbb was returning pathetically low numbers which turns out to be
because all threads are running on just one of the cpus

	-Dinakar


>  Any suggestions on further debugging this?
> 
> thanks
> -john
