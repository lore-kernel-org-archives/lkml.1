Return-Path: <linux-kernel-owner+w=401wt.eu-S1422950AbXDXR65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422950AbXDXR65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422953AbXDXR65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:58:57 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422952AbXDXR64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:58:56 -0400
Date: Tue, 24 Apr 2007 10:57:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Prarit Bhargava <prarit@redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
Message-Id: <20070424105738.e0ce36a9.akpm@linux-foundation.org>
In-Reply-To: <462E43A7.1050001@goop.org>
References: <20070327214919.800272641@goop.org>
	<20070327215827.871954359@goop.org>
	<20070423234910.50149faf.akpm@linux-foundation.org>
	<462E43A7.1050001@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 10:51:35 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > It seems fairly sensitive to .config settings.  See
> > http://userweb.kernel.org/~akpm/config-sony.txt
> >   
> 
> I haven't tried your config yet, but I haven't managed to reproduce it
> by playing with the usual suspects in my config (SMP, PREEMPT).  Any
> idea about which config changes make the difference?

I said that because the damn thing went away when I was hunting it down
because I lost the config and was unable to remember the right combination
of debug settings.  Fortunately it later came back so I took care to
preserve the config.

> Hm, is it caused by using sched_clock() to generate the printk
> timestamps while generating the lock test output?

Conceivably.  What does that locking API test do?

I was using printk timestamps and netconsole at the time.
