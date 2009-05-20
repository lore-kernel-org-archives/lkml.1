Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbZETGLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbZETGLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 02:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZETGK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 02:10:56 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49704 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZETGK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 02:10:56 -0400
Subject: Re: [PATCH] Remove indirect variable usage at arch/x86/kernel/tsc.c
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Frans Pop <elendil@planet.nl>
Cc: x86@kernel.org, sachinp@linux.vnet.ibm.com, hpa@zytor.com,
       andi@firstfloor.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       mingo@redhat.com, balbir@linux.vnet.ibm.com
In-Reply-To: <200905192054.00377.elendil@planet.nl>
References: <20090519180302.603.3124.sendpatchset@subratamodak.linux.ibm.com>
	 <200905192054.00377.elendil@planet.nl>
Content-Type: text/plain
Organization: IBM
Date: Wed, 20 May 2009 11:40:40 +0530
Message-Id: <1242799841.5712.7.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 20:53 +0200, Frans Pop wrote:
> Subrata Modak wrote:
> > 640         if (!(freq->flags & CPUFREQ_CONST_LOOPS))
> > 641 #ifdef CONFIG_SMP
> > 642                 lpj = &cpu_data(freq->cpu).loops_per_jiffy;
> > 643 #else
> > 644         lpj = &boot_cpu_data.loops_per_jiffy;
> > 645 #endif
> 
> No comments on your patch, but it might be good to also fix the incorrect 
> indentation here: line 644 needs an extra tab.

Sure, i will do that in the updated patch.

Regards--
Subrata

> 
> Cheers,
> FJP

