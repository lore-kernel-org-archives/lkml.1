Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbZHABUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbZHABUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 21:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZHABUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 21:20:07 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41604 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZHABUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 21:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OaKYOvtbjglYr7H1v7449t71iOWX9nEbbF1yDMsiixOuiV1/WKVwR4YuMCX6pMFJ20
         /noaTu9FAqKEOxSZjbMq6ncOgw/e/G2q2eUK2U+5w/AaFeUgO6etg7Wai/KnA/xiFgYV
         zU3ic0pDyVzSRZGqmMbvthhfY0vwdDVuivARo=
Date: Sat, 1 Aug 2009 03:20:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20090801012000.GA5309@nowhere>
References: <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain> <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain> <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <20090731232205.GA7574@nowhere> <4A738F78.9020106@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A738F78.9020106@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 05:42:32PM -0700, Darren Hart wrote:
> Frederic Weisbecker wrote:
>> On Thu, Jul 30, 2009 at 02:48:04AM +0200, Thomas Gleixner wrote:
>
>>> Further plans:
>>>
>>>    1) We seriously want to tackle the elimination of the PREEMPT_RT
>>>    annoyance #1, aka BKL. The Big Kernel Lock is still used in ~330
>>>    files all across the kernel. A lot of work has been done already to
>>>    push down the lock into the code which still thinks it needs to be
>>>    protected by it. Some work has been done already in the (a little
>>>    bit stale) kill-the-BKL and core/kill-the-BKL branches of the -tip
>>>    git tree. If you want to help, please check those branches whether
>>>    the code has been tackled already or not to avoid redundant
>>>    work. If you decide to take care of one please note it on:
>>>
>>>        http://rt.wiki.kernel.org/index.php/Big_Kernel_Lock
>>
>>
>> We (I) can't write to this file :)
>>
>> However, I'll try to attack the remaining bkl that resides in tty...
>
> I took a look at the perms, then the history - looks like you sorted it out.


Yeah, I just had to register. I'm an idiot.

Thanks!


> -- 
> Darren Hart
> IBM Linux Technology Center
> Real-Time Linux Team

