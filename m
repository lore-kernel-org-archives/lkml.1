Return-Path: <linux-kernel-owner+w=401wt.eu-S1422889AbXDXRvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422889AbXDXRvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422907AbXDXRvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:51:16 -0400
Received: from gw.goop.org ([64.81.55.164]:51488 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422889AbXDXRvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:51:15 -0400
Message-ID: <462E43A7.1050001@goop.org>
Date: Tue, 24 Apr 2007 10:51:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Prarit Bhargava <prarit@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
References: <20070327214919.800272641@goop.org>	<20070327215827.871954359@goop.org> <20070423234910.50149faf.akpm@linux-foundation.org>
In-Reply-To: <20070423234910.50149faf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> It seems fairly sensitive to .config settings.  See
> http://userweb.kernel.org/~akpm/config-sony.txt
>   

I haven't tried your config yet, but I haven't managed to reproduce it
by playing with the usual suspects in my config (SMP, PREEMPT).  Any
idea about which config changes make the difference?

Hm, is it caused by using sched_clock() to generate the printk
timestamps while generating the lock test output?

    J
