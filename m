Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZHAAmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZHAAmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 20:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZHAAmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 20:42:38 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45784 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbZHAAmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 20:42:37 -0400
Message-ID: <4A738F78.9020106@us.ibm.com>
Date: Fri, 31 Jul 2009 17:42:32 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
References: <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain> <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain> <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain> <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <20090731232205.GA7574@nowhere>
In-Reply-To: <20090731232205.GA7574@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Jul 30, 2009 at 02:48:04AM +0200, Thomas Gleixner wrote:

>> Further plans:
>>
>>    1) We seriously want to tackle the elimination of the PREEMPT_RT
>>    annoyance #1, aka BKL. The Big Kernel Lock is still used in ~330
>>    files all across the kernel. A lot of work has been done already to
>>    push down the lock into the code which still thinks it needs to be
>>    protected by it. Some work has been done already in the (a little
>>    bit stale) kill-the-BKL and core/kill-the-BKL branches of the -tip
>>    git tree. If you want to help, please check those branches whether
>>    the code has been tackled already or not to avoid redundant
>>    work. If you decide to take care of one please note it on:
>>
>>        http://rt.wiki.kernel.org/index.php/Big_Kernel_Lock
> 
> 
> We (I) can't write to this file :)
> 
> However, I'll try to attack the remaining bkl that resides in tty...

I took a look at the perms, then the history - looks like you sorted it out.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
