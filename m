Return-Path: <linux-kernel-owner+w=401wt.eu-S1030843AbXDVNAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030843AbXDVNAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030837AbXDVNAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:00:36 -0400
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:37228 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030843AbXDVNAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:00:35 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Renice X for cpu schedulers
Date: Sun, 22 Apr 2007 22:58:13 +1000
User-Agent: KMail/1.9.5
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070417062621.GL2986@holomorphy.com> <462A25DD.2050702@rtr.ca> <462B5B04.3060309@rtr.ca>
In-Reply-To: <462B5B04.3060309@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704222258.14056.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007 22:54, Mark Lord wrote:
> Just to throw another possibly-overlooked variable into the mess:
>
> My system here is using the on-demand cpufreq policy governor.
> I wonder how that interacts with the various schedulers here?
>
> I suppose for the "make" kernel case, after a couple of seconds
> the cpufreq would hit max and stay there for the rest of the build,
> so it shouldn't really be a factor for (non-)interactivity during the
> build.
>
> Or should it?

Short answer: shouldn't matter :)

-- 
-ck
