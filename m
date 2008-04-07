Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYDGQc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYDGQc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 12:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYDGQcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 12:32:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35429 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYDGQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 12:32:50 -0400
Subject: Re: [PATCH] Close small window for vsyscall time inconsistencies
From: John Stultz <johnstul@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <874padsy5b.fsf@basil.nowhere.org>
References: <1207340264.6222.17.camel@localhost.localdomain>
	 <874padsy5b.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 09:32:42 -0700
Message-Id: <1207585962.6138.4.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-07 at 13:27 +0200, Andi Kleen wrote:
> john stultz <johnstul@us.ibm.com> writes:
> >
> > The update_vsyscall then runs, and updates the clocksource frequency
> > with a slower frequency.
> 
> In the new code TSC should be only used on fixed-pstate TSC systems
> (cpufreq always marks it unstable), so that cannot really happen.

Sorry for being confusing here. This is not about hardware (TSC or
other) frequency changes, but the modification of the software's
representation of the frequency (as done w/ NTP adjustments).

thanks
-john

