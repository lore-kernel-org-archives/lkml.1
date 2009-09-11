Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZIKSKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZIKSKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZIKSKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:10:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46971 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZIKSKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:10:47 -0400
Subject: Re: [PATCH] update clocksource raw_time in timekeeping_suspend
From: john stultz <johnstul@us.ibm.com>
To: ye janboe <janboe.ye@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, zippel@linux-m68k.org,
       akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <af3ea28a0909102035r5b39f3f5he8885996cf55fa65@mail.gmail.com>
References: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
	 <1252537622.9883.24.camel@localhost.localdomain>
	 <af3ea28a0909100107q328d1288x8d677d4d5f79f728@mail.gmail.com>
	 <2674af740909100231x582851dbv9b71bc2914be7030@mail.gmail.com>
	 <1252620938.7319.3.camel@localhost.localdomain>
	 <af3ea28a0909102035r5b39f3f5he8885996cf55fa65@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 11:09:04 -0700
Message-Id: <1252692544.7913.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 11:35 +0800, ye janboe wrote:
> So CLOCK_MONOTONIC_RAW is not suitable for getting real hw time which
> includes sleep time.

Hmm.. This is sort of an odd request. 

The clocksource hardware counters stop in during suspend, so any "real
hw time that includes sleep" is likely to be combined from different
sources (with slightly different drifts), so I'm not sure why
CLOCK_MONOTONIC_RAW would be preferred over CLOCK_MONOTONIC?


> Is there other timer suitable for this?

Maybe the CMOS / RTC?  Would that suffice?

Could you maybe provide more details about why you need this? Maybe
better understanding your needs would help point to a solution.

thanks
-john


