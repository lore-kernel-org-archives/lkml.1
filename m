Return-Path: <linux-kernel-owner+w=401wt.eu-S1763100AbXJZU6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763100AbXJZU6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbXJZU54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:57:56 -0400
Received: from hpsmtp-eml14.KPNXCHANGE.COM ([213.75.38.114]:41513 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758593AbXJZU5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:57:55 -0400
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.624-rc1 regression] lost battery information
Cc: arvidjaar@mail.ru, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-To: <472232D3.6000807@gmail.com>
References: <200710262024.06012.arvidjaar@mail.ru> <200710262120.22536.arvidjaar@mail.ru> <47222DF3.3040208@gmail.com> <200710262215.42939.arvidjaar@mail.ru> <472232D3.6000807@gmail.com>
Message-Id: <E1IlWFd-0002fD-6c@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 26 Oct 2007 22:57:53 +0200
X-OriginalArrivalTime: 26 Oct 2007 20:57:53.0381 (UTC) FILETIME=[E06D8150:01C81812]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Andrey Borzenkov wrote:
>> is it in -rc1 or can you point me to the patch (I'd rather avoid having
>> to pull from different git trees). Thank you.
> No, it should be rc1.
>> 
>> And what about ACPI_PROCFS case? It still needs attention I believe.
> As you can see, there is info in /proc too:

I'm missing the info in /sys too, so it looks like the error in proc and
the missing info in /sys are related.

Alexey: do you have POWER_SUPPLY and/or AC/BATTERY compiled in or modular?
I wonder if that could make the difference.
