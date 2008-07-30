Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYG3HOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYG3HOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYG3HOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:14:12 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:38501 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYG3HOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:14:11 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: bug? 2.6.26-rc8-mm1, corrupted dcache 
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200807301652.23024.nickpiggin@yahoo.com.au>
References: <9886.1217400028@jrobl> <200807301652.23024.nickpiggin@yahoo.com.au>
Date: Wed, 30 Jul 2008 16:14:05 +0900
Message-ID: <10128.1217402045@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin:
> This looks a bit like the PREEMPT_RCU problem that was fixed just
> before 2.6.26. Do you have PREEMPT_RCU=y and HOTPLUG_CPU=n in your
> config?

Exactly.
So next -mm release will not have this problem. Anyway I will check it
again.
Thanks.

$ gunzip -c /proc/config.gz | egrep '(_RCU|HOTPLUG)'
CONFIG_HOTPLUG=y
# CONFIG_CLASSIC_RCU is not set
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_HOTPLUG_PCI is not set


Junjiro Okajima
