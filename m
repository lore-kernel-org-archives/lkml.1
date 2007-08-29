Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbXH2P0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbXH2P0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbXH2P00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:26:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43396 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbXH2P0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:26:25 -0400
Date: Wed, 29 Aug 2007 17:26:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
cc: DervishD <lkml@dervishd.net>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cpufreq affects traffic control rates
In-Reply-To: <20070828152309.7fe1ce91@freepuppy.rosehill.hemminger.net>
Message-ID: <Pine.LNX.4.64.0708291725000.24730@fbirervta.pbzchgretzou.qr>
References: <20070828075155.GG17475@DervishD> <20070828152309.7fe1ce91@freepuppy.rosehill.hemminger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28 2007 15:23, Stephen Hemminger wrote:
>>     I noticed lately that my traffic control rates were being very slow,
>> about 40% less than expected, and finally spotted the problem: cpufreq.
>> 
>>     Looks like HTB puts buckets according to the requested rate but
>> assuming that the CPU is running at its default clock or something like
>> that.
>> 
>Is the problem configuration of network scheduler clock? In 2.6.20 and earlier, you
>could use CPU cycle counter (later kernels only use time of day).  So try
>switching to jiffies or gettimeofday.

This should not have been removed. CPUs with constant_tsc
could still be used with "CPU cycle counter" method.


	Jan
-- 
