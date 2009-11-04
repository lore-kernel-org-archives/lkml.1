Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZKDCTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZKDCTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZKDCTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:19:43 -0500
Received: from smtp4.Stanford.EDU ([171.67.219.84]:35538 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754103AbZKDCTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:19:41 -0500
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 21:19:40 EST
Subject: Re: [ANNOUNCE] 2.6.31.4-rt14
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
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
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
	 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
	 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 02:13:10 +0000
Message-Id: <1257300790.25489.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 12:02 +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>    - Forward to 2.6.31.4

Could some guru rebase to 2.6.31.5 please?
I get two failed chunks in kernel/futex.c

Would be appreciated...
-- Fernando

>    - Handle futex spurious wakeups
>    - slab fixes for NUMA (peterz)
> 
> The slab problem is still not completely resolved. It's hard to
> reproduce and was only seen on Nehalem dual socket systems so far. If
> you have such a machine you might help providing a back trace, just run
> 
>  while true; do hackbench N; done
> 
> until it explodes. Adjust N to your system, the larger the
> better. Make sure you have a serial console to capture the oops.
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
> to build the 2.6.31.4-rt14 tree, the following patches should be
> applied:
> 
>     http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.31.4.tar.bz2
>     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31.4-rt14.bz2
> 
> Enjoy !
> 
>       tglx

