Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbXDLRni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbXDLRni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXDLRni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:43:38 -0400
Received: from gw.goop.org ([64.81.55.164]:33312 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbXDLRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:43:38 -0400
Message-ID: <461E6FA7.5080605@goop.org>
Date: Thu, 12 Apr 2007 10:43:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@novell.com>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
References: <20070411162904.232696302@mvista.com>	<200704121136.03098.ak@novell.com>	<20070412092348.70a4de05.akpm@linux-foundation.org>	<200704121845.39961.ak@novell.com> <20070412100039.00ace23f.akpm@linux-foundation.org>
In-Reply-To: <20070412100039.00ace23f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> hm.  People (ab)use sched_clock() for all sorts of things nowadays.  I wouldn't
> do anything to degrade it just on behalf of printk-timestamping.
>   

printk was the only non-scheduler-ish use I could find.  Are there others?

    J
