Return-Path: <linux-kernel-owner+w=401wt.eu-S1423017AbXDXUsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423017AbXDXUsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423089AbXDXUsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:48:11 -0400
Received: from gw.goop.org ([64.81.55.164]:48462 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423017AbXDXUsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:48:09 -0400
Message-ID: <462E6D20.5000108@goop.org>
Date: Tue, 24 Apr 2007 13:48:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Prarit Bhargava <prarit@redhat.com>, Rick Lindsley <ricklind@us.ibm.com>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, virtualization@lists.osdl.org,
       Chris Lalancette <clalance@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
References: <20070327214919.800272641@goop.org>	<20070327215827.871954359@goop.org>	<20070423234910.50149faf.akpm@linux-foundation.org>	<462E43A7.1050001@goop.org>	<20070424105738.e0ce36a9.akpm@linux-foundation.org>	<462E4969.6070802@goop.org>	<20070424113222.ed2e1314.akpm@linux-foundation.org>	<462E61F1.7060403@goop.org>	<462E6778.7070305@goop.org> <20070424133359.f18bce78.akpm@linux-foundation.org>
In-Reply-To: <20070424133359.f18bce78.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> It's weird.  And I don't think the locking selftest code calls
> sched_clock() (or any other time-related thing) at all, does it?
>   

I guess it ends up going through the scheduler, which does use it. 
But... <shrug>

    J
