Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZGJSMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZGJSMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZGJSMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:12:33 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:48247 "EHLO
	smtp4.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZGJSMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:12:32 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jul 2009 14:12:32 EDT
Subject: Re: [ANNOUNCE] 2.6.29.6-rt23
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
       Jon Masters <jcm@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 11:03:22 -0700
Message-Id: <1247249002.18898.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 20:25 +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
>  
>      - update to 2.6.29.6
>  
>      - compile fixes (Wu Zhangjin)
> 
>      - powerpc highmem fix
> 
>      - hwlat smp_processor_id() fix (Carsten)
> 
>      - ktime_get* speedups (Martin)

I'm getting slightly weird behavior from rt23 in an intel quad core
machine (my T61 laptop is fine), rt22 was fine. It is some timer issue,
if I type continuously I get (every few seconds) repeated keys. Nothing
in the logs, nothing in dmesg that is (significantly) different from an
rt22 boot. 

-- Fernando


> Download locations:
> 
>     http://rt.et.redhat.com/download/
>     http://www.kernel.org/pub/linux/kernel/projects/rt/
> 
> Information on the RT patch can be found at:
> 
>     http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.29.6-rt23 tree, the following patches should be
> applied:
> 
>     http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.6.tar.bz2
>     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.6-rt22.bz2
> 
> The broken out patches are also available at the same download
> locations.
> 
> Enjoy !
> 
>        tglx
> 
> P.S.: 30-rt is coming close and runs the final tests right now

