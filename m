Return-Path: <linux-kernel-owner+w=401wt.eu-S1761192AbXEQGmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192AbXEQGmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXEQGmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:42:43 -0400
Received: from sumo.dreamhost.com ([66.33.216.29]:59442 "EHLO
	sumo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbXEQGmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:42:42 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: tglx@linutronix.de
Subject: Re: [BUG] local_softirq_pending storm
Date: Thu, 17 May 2007 12:11:22 +0530
User-Agent: KMail/1.9.6
References: <200705091942.22920.kernel@prachanda.hub> <d95aa510705100453y666cf310ic9ee4dc609f099f1@mail.gmail.com> <1178834326.22481.18.camel@localhost.localdomain>
In-Reply-To: <1178834326.22481.18.camel@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171211.23350.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2007 03:28:46 Thomas Gleixner wrote:

> Ok, that's consistent with earlier reports. The problem surfaces when
> one of the SMT-"cpus" goes idle. The problem goes away when you disable
> hyperthreading.
Yes with HT disabled in BIOS there is no local_softirq_pending messages. BTW 
why does this problem persist only with X ? 

> When you apply the ratelimit patch, does the softlockup problem
> persist ?
>
Yes, though softlockup is rare and mostly hit when system is under high load. 
Apart of that I am also getting following messages consistently across 
multiple boot cycles with NOHZ=y and ratelimit patch applied.

May 15 11:51:22 rudra kernel: [ 2594.341068] Clocksource tsc unstable (delta = 
28111260302 ns)
May 15 11:51:22 rudra kernel: [ 2594.343194] Time: acpi_pm clocksource has 
been installed.
