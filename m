Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYDGL1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYDGL1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 07:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbYDGL1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 07:27:32 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:26060 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYDGL1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 07:27:31 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Close small window for vsyscall time inconsistencies
From: Andi Kleen <andi@firstfloor.org>
References: <1207340264.6222.17.camel@localhost.localdomain>
Date: Mon, 07 Apr 2008 13:27:28 +0200
In-Reply-To: <1207340264.6222.17.camel@localhost.localdomain> (john stultz's message of "Fri, 04 Apr 2008 13:17:44 -0700")
Message-ID: <874padsy5b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Apr 2008 11:20:45.0923 (UTC) FILETIME=[6C99BB30:01C898A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> writes:
>
> The update_vsyscall then runs, and updates the clocksource frequency
> with a slower frequency.

In the new code TSC should be only used on fixed-pstate TSC systems
(cpufreq always marks it unstable), so that cannot really happen.

Jiri had his patchkit to fix that, but it never got merged.

-Andi
