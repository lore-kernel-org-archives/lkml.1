Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZESSyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZESSyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZESSyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:54:07 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:50438 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbZESSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:54:06 -0400
From: Frans Pop <elendil@planet.nl>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: Re: [PATCH] Remove indirect variable usage at arch/x86/kernel/tsc.c
Date: Tue, 19 May 2009 20:53:57 +0200
User-Agent: KMail/1.9.9
Cc: x86@kernel.org, sachinp@linux.vnet.ibm.com, hpa@zytor.com,
       andi@firstfloor.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       mingo@redhat.com, subrata@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com
References: <20090519180302.603.3124.sendpatchset@subratamodak.linux.ibm.com>
In-reply-To: <20090519180302.603.3124.sendpatchset@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905192054.00377.elendil@planet.nl>
X-OriginalArrivalTime: 19 May 2009 18:54:01.0066 (UTC) FILETIME=[2C4B7CA0:01C9D8B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
> 640         if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> 641 #ifdef CONFIG_SMP
> 642                 lpj = &cpu_data(freq->cpu).loops_per_jiffy;
> 643 #else
> 644         lpj = &boot_cpu_data.loops_per_jiffy;
> 645 #endif

No comments on your patch, but it might be good to also fix the incorrect 
indentation here: line 644 needs an extra tab.

Cheers,
FJP
