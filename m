Return-Path: <linux-kernel-owner+w=401wt.eu-S933436AbZHEGGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436AbZHEGGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbZHEGGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:06:34 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42797 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbZHEGGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:06:33 -0400
Message-ID: <4A79214B.5070003@linux.vnet.ibm.com>
Date: Wed, 05 Aug 2009 11:36:03 +0530
From: gowrishankar <gowrishankar.m@linux.vnet.ibm.com>
Reply-To: gowrishankar.m@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain> <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain> <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain> <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain> <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain> <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain> <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain> <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain> <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>     - update to 2.6.31-rc4

Hi,
I am seeing below kernel panic on 8 way Intel and 4 way AMD blades.

Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: init Not tainted 2.6.31-rc4-rt1-autotest #1
Call Trace:
  [<ffffffff8104c887>] panic+0xc1/0x171
  [<ffffffff8104ec9a>] ? put_files_struct+0xc3/0xe6
  [<ffffffff81394313>] ? rt_write_unlock+0x1c/0x32
  [<ffffffff810582fd>] ? exit_ptrace+0xab/0x130
  [<ffffffff81394313>] ? rt_write_unlock+0x1c/0x32
  [<ffffffff810500af>] do_exit+0x88/0x726
  [<ffffffff810507d5>] do_group_exit+0x88/0xbb
  [<ffffffff8105082d>] sys_exit_group+0x25/0x3d
  [<ffffffff8100be2b>] system_call_fastpath+0x16/0x1b

Thanks,
Gowri
