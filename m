Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYE2Ot1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYE2Ot1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYE2OtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:49:20 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:48848 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbYE2OtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:49:19 -0400
Message-ID: <483EC257.60009@nortel.com>
Date: Thu, 29 May 2008 08:48:55 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: James Cammarata <jimi@sngx.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool - e1000/pcnet32
References: <482DA5B6.1020606@sngx.net>	<482DB46A.8020103@cosmosbay.com> <482EF192.4070707@sngx.net>	<482F5113.5090703@cosmosbay.com> <482F610D.2080108@sngx.net>	<20080518003104.GK28241@solarflare.com> <482FBA09.80201@sngx.net>	<483E0AAE.2020107@sngx.net> <20080528221118.63da4092.akpm@linux-foundation.org> <483EA2D1.8050603@sngx.net>
In-Reply-To: <483EA2D1.8050603@sngx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2008 14:49:00.0195 (UTC) FILETIME=[213F5730:01C8C19B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Cammarata wrote:
>> You didn't provide a reason from adding this feature to the kernel.

> Sorry, my reasoning was in my original patch only.  The ability to reset 
> network counters is, in my experience, one of the first things you do 
> when trying to troubleshoot networking issues - especially when you have 
> incrementing errors.

The ability to reset counters does make it easier to detect changes 
manually, as any non-zero value is something of interest.  However, if 
you're gathering data via a script there is no functional gain.

>> Many of the kernel's accounting accumulators cannot be reset.  We
>> handle that in userspace tools by using subtraction.

> I don't think that should preclude the ability to reset these, unless it is
> shown that it would break something very badly.

You're trying to add new functionality to the kernel, increasing its 
size and adding more work for maintainers.  Also, you're implicitly 
asking that all of the network drivers be updated to add support for 
this feature.  The burden of proof is on you to show why the feature is 
useful enough that the others involved should take on this additional work.

Chris
