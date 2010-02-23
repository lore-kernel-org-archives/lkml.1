Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0BWTIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:08:07 -0500
Received: from smtp3.Stanford.EDU ([171.67.219.83]:35658 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753817Ab0BWTIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:08:05 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 14:08:04 EST
Subject: Re: [ANNOUNCE] 2.6.31.12-rt21
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
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
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
	 <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain>
	 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
	 <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
	 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 11:01:15 -0800
Message-Id: <1266951675.2507.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 17:54 +0100, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>      - fixes and cherry-picks all over the place
> 
>      - tracer fixes from Carsten 

Seeing this here, otherwise seems fine:

BUG: sleeping function called from invalid context at
arch/x86/mm/highmem_32.c:9
in_atomic(): 1, irqs_disabled(): 0, pid: 1984, name: Xorg
Pid: 1984, comm: Xorg Not tainted
2.6.31.12-1.rt21.1.fc11.ccrma.i686.rtPAE #1
Call Trace:
 [<c0431852>] __might_sleep+0xc6/0xcb
 [<c042b494>] kmap+0x47/0x5a
 [<f8049ca7>] i915_gem_pwrite_ioctl+0x3ea/0x631 [i915]
 [<f7f61721>] drm_ioctl+0x208/0x2a9 [drm]
 [<f80498bd>] ? i915_gem_pwrite_ioctl+0x0/0x631 [i915]
 [<c0589d80>] ? inode_has_perm+0x69/0x84
 [<c07a31ff>] ? rt_mutex_lock+0x28/0x2b
 [<c046a7f3>] ? rt_down+0x1a/0x1d
 [<c04e6581>] vfs_ioctl+0x5c/0x76
 [<c04e6ae9>] do_vfs_ioctl+0x4a0/0x4de
 [<c058a00f>] ? selinux_file_ioctl+0x43/0x46
 [<c04e6b6d>] sys_ioctl+0x46/0x66
 [<c04090d3>] sysenter_do_call+0x12/0x28

-- Fernando


