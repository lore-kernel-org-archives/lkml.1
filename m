Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbZCCWIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbZCCWIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbZCCWAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274AbZCCWAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:00:38 -0500
Message-ID: <49ADA840.4010909@zytor.com>
Date: Tue, 03 Mar 2009 13:59:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dimitri Sivanich <sivanich@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6 v6] SGI RTC: add clocksource driver
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com> <20090303151524.GB20120@sgi.com> <20090303151657.GC20120@sgi.com> <20090303151827.GD20120@sgi.com> <20090303152016.GE20120@sgi.com> <20090303152206.GF20120@sgi.com> <20090303153553.GB29454@elte.hu>
In-Reply-To: <20090303153553.GB29454@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
>>  drivers/clocksource/Makefile |    1 
>>  drivers/clocksource/rtc_uv.c |  381 +++++++++++++++++++++++++++++++++++++++
>>  drivers/misc/Kconfig         |    9 
> 
> btw., since this is a platform driver, i'd suggest to move it to 
> arch/x86/kernel/uv_time.c or so.
> 

I thought we agreed platforms drivers go in drivers/x86?

	-hpa
