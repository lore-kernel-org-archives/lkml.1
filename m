Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbZIWVdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbZIWVdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZIWVdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:33:52 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48515 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZIWVdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:33:49 -0400
Subject: Re: [ANNOUNCE] 2.6.31-rt11
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	 <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	 <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
	 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
	 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain>
	 <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Wed, 23 Sep 2009 16:33:48 -0500
Message-Id: <1253741628.5001.4.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 00:39 +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>    - latencytop fix
> 
>    - disable SPARSE_IRQ, DMAR, IRQ_REMAP for -rt
> 
> Known issues:
>    - ARM highmem
>    - scheduler load balancing oddities. Peter is working on it.
>    - timer_interrupt hang check (still working on somthing useful)
> 
> The planned "add back MIPS support" is postponed to rt12.


Just a light workload and a couple boot tests so far, 2.6.31-rt11
appears to be running good on my powerpc64 systems.  (power6 JS22
blades).  

Thanks. :-)
-Will



> 
> Download locations:
> 
>     http://rt.et.redhat.com/download/
>     http://www.kernel.org/pub/linux/kernel/projects/rt/
> 
> Git release branch:
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.31
>   
> Git development branch:
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head
> 
> Gitweb:
>     http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.31
> 
> Information on the RT patch can be found at:
> 
>     http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.31-rt11 tree, the following patches should be
> applied:
> 
>     http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.31.tar.bz2
>     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31-rt11.bz2
> 
> Enjoy !
> 
>       tglx
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

