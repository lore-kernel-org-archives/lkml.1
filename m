Return-Path: <linux-kernel-owner+w=401wt.eu-S1161304AbXCNUzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161304AbXCNUzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161325AbXCNUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:55:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51857 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161304AbXCNUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:55:47 -0400
Subject: Re: [PATCH] hrtimer: Fixup unlocked access to wall_to_monotonic
From: john stultz <johnstul@us.ibm.com>
To: tglx@linutronix.de
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1173905840.13341.192.camel@localhost.localdomain>
References: <1173905840.13341.192.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 13:55:43 -0700
Message-Id: <1173905743.2422.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 21:57 +0100, Thomas Gleixner wrote:
> commit f4304ab21513b834c8fe3403927c60c2b81a72d7 (HZ free NTP) moved the
> access to wall_to_monotonic in hrtimer_get_softirq_time() out of the
> xtime_lock protection.
> 
> Move it back into the seq_lock section.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Ek! Thanks Thomas!
Acked-by: John Stultz <johnstul@us.ibm.com>


