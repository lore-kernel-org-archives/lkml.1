Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbXC0Qhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbXC0Qhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933131AbXC0Qhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:37:52 -0400
Received: from gw.goop.org ([64.81.55.164]:39772 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXC0Qhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:37:51 -0400
Message-ID: <46094861.7080400@goop.org>
Date: Tue, 27 Mar 2007 09:37:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: Re: [patch 1/2] Ignore stolen time in the softlockup watchdog
References: <20070327053816.881735237@goop.org> <20070327054106.664262413@goop.org> <46092C9B.4030700@redhat.com>
In-Reply-To: <46092C9B.4030700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava wrote:
> I'd like to see this patch implement/fix touch_cpu_softlockup_watchdog
> and touch_softlockup_watchdog to mimic touch_nmi_watchdog's behaviour.

Why?  Is that more correct?  It seems to me that you're interested in
whether a specific CPU has gone and locked up.  If touching the watchdog
makes it update all CPU timestamps, then you'll hide the fact that other
CPUs have locked up, won't it?

    J
