Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbXH2H7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbXH2H7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 03:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXH2H7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 03:59:45 -0400
Received: from smtp.cdmon.com ([212.36.74.230]:57695 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbXH2H7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 03:59:44 -0400
Date: Wed, 29 Aug 2007 09:59:36 +0200
From: DervishD <lkml@dervishd.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cpufreq affects traffic control rates
Message-ID: <20070829075936.GD18688@DervishD>
Mail-Followup-To: Stephen Hemminger <shemminger@linux-foundation.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070828075155.GG17475@DervishD> <20070828152309.7fe1ce91@freepuppy.rosehill.hemminger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070828152309.7fe1ce91@freepuppy.rosehill.hemminger.net>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Stephen :)

 * Stephen Hemminger <shemminger@linux-foundation.org> dixit:
> On Tue, 28 Aug 2007 09:51:55 +0200 DervishD <lkml@dervishd.net>
> wrote:
> >     I noticed lately that my traffic control rates were being very
> >     slow, about 40% less than expected, and finally spotted the
> >     problem: cpufreq.
> 
> Is the problem configuration of network scheduler clock? In 2.6.20 and
> earlier, you could use CPU cycle counter (later kernels only use time
> of day).  So try switching to jiffies or gettimeofday.

    Yes, the problem is that I'm stupid and I thought I was using
jiffies, but I have CONFIG_NET_SCH_CLK_CPU. I'll rebuild my kernel ASAP
and set the proper value...

    Thanks for your help. It's embarrassing I didn't check the clock
source for the packet scheduler...

    Sorry for the noise.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
