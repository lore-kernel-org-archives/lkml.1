Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbXLBUBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbXLBUBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbXLBUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:00:48 -0500
Received: from lazybastard.de ([212.112.238.170]:42999 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbXLBUAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:00:47 -0500
Date: Sun, 2 Dec 2007 20:55:02 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202195501.GB10657@lazybastard.org>
References: <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org> <20071202135711.GA20434@elte.hu> <20071202141117.GB9516@lazybastard.org> <20071202154746.GA27069@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071202154746.GA27069@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 December 2007 16:47:46 +0100, Ingo Molnar wrote:
> 
> well what does the trace say, where do the delays come from? To get a 
> quick overview you can make tracing lighter weight by doing:
> 
>  echo 0 > /proc/sys/kernel/mcount_enabled
>  echo 1 > /proc/sys/kernel/trace_syscalls

I mistyped and did 
 echo 1 > /proc/sys/kernel/mcount_enabled

Result looked like a livelock and finally convinced me to abandon the
latency tracer.  Sorry, but it appears to be the right tool for the
wrong job.

Jörn

-- 
They laughed at Galileo.  They laughed at Copernicus.  They laughed at
Columbus. But remember, they also laughed at Bozo the Clown.
-- unknown
