Return-Path: <linux-kernel-owner+w=401wt.eu-S1751154AbXA2Qha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbXA2Qha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 11:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXA2Qha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 11:37:30 -0500
Received: from www.osadl.org ([213.239.205.134]:48410 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751154AbXA2Qh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 11:37:29 -0500
Subject: Re: 2.6.20-rc6-mm2
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200701291722.41705.fzu@wemgehoertderstaat.de>
References: <20070129001207.71ea3470.akpm@osdl.org>
	 <200701291722.41705.fzu@wemgehoertderstaat.de>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 17:38:08 +0100
Message-Id: <1170088688.29240.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 17:22 +0100, Karsten Wiese wrote:
> Hi,
> 
> with dynticks and highres_timers enabled, cpufreq_ondemand makes mess here on
> an AMD64 UP.
> cpufreq_ondemand assumes that jiffies advance at exactly the same pace as the
> sum of all kstat_cpu(cpu).cpustat.* members.
> This isn't the case here as dmesg output from patch below shows.
> 
> Is cpufreq_ondemand correct assuming
>  "jiffies advance at exactly the same pace as the
>   sum of all kstat_cpu(cpu).cpustat.* members"?
> Or is "dynticks and highres_timers"'s behaviour of incrementing the
> sum of  kstat_cpu(cpu).cpustat.* members faster than jiffies?

No it should not. /me investigates.

	tglx


