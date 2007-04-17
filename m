Return-Path: <linux-kernel-owner+w=401wt.eu-S1031281AbXDQWNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031281AbXDQWNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031289AbXDQWNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:13:30 -0400
Received: from mail.tmr.com ([64.65.253.246]:41371 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031291AbXDQWN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:13:29 -0400
Message-ID: <46254666.2020308@tmr.com>
Date: Tue, 17 Apr 2007 18:12:54 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <200704131022.45315.rjw@sisk.pl>
In-Reply-To: <200704131022.45315.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> [appropriate CCs added]
> 
> On Friday, 13 April 2007 02:33, Robert P. J. Day wrote:
>> just something i threw together, not in final form, but it represents
>> tossing the legacy PM stuff.  at the moment, the menuconfig entry for
>> PM_LEGACY lists it as "DEPRECATED", while the help screen calls it
>> "obsolete."  that's a good sign that it's getting close to the time
>> for it to go, and the removal is fairly straightforward, but there's
>> no mention of its removal in the feature removal schedule file.
> 
> It's been like this for a long long time.  I think you're right that it can be
> dropped, but I don't know the details (eg. why it hasn't been dropped yet).
>  
One reason was that there are (were?) a number of machines which only 
powered down properly using apm. It was discussed as part of shutting 
down after power failure when your UPS is running out of power.

I haven't checked on that in a while, I'm just supplying one reason 
since you wondered.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
