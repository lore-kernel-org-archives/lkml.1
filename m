Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZELFj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZELFj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 01:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZELFjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 01:39:49 -0400
Received: from smtp.nokia.com ([192.100.105.134]:27962 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZELFjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 01:39:49 -0400
Message-ID: <4A090B52.7040301@yandex.ru>
Date: Tue, 12 May 2009 08:38:26 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jussi Laako <jussi@sonarnerd.net>, Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net> <1232954745.4863.4.camel@laptop> <4A07E044.8040807@sonarnerd.net>
In-Reply-To: <4A07E044.8040807@sonarnerd.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 May 2009 05:38:29.0095 (UTC) FILETIME=[E0EE7770:01C9D2C3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jussi Laako wrote:
> Peter Zijlstra wrote:
>> Right, and I think the solution to this problem is twofold, 1)
>> application writers should start writing (soft) realtime applications if
>> they want (soft) realtime behaviour -- there's just no way around that.
> 
> Just to avoid need for reviewing and reworking ~800 klocs of user space
> code in just gstreamer, here's a second take on patches. This time
> splitting things into smaller pieces. Attached patch exposes 40
> priorities ~ nice values as something accessible through
> sched_()/pthreads API in order to control priorities of individual
> threads. Current Linux implementation of SCHED_OTHER is broken in a way,
> that it exposes only one single priority level - 0. Thus no possibility
> to properly control priorities of threads through pthread API. This is
> patch is against 2.6.29.2 and not tested, but builds. I can also send
> rest of the changes as separate small feature patches as needed.
> However, before doing any more work I would like to hear opinions on
> this and especially what is wrong with the code or idea...

Ingo,

would it be possible to comment on this?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
