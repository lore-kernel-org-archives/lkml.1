Return-Path: <linux-kernel-owner+w=401wt.eu-S1750910AbXB0OC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbXB0OC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXB0OC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:02:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXB0OC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:02:56 -0500
Message-ID: <45E439E4.5030703@redhat.com>
Date: Tue, 27 Feb 2007 09:02:12 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
CC: Hiro Yoshioka <hyoshiok@miraclelinux.com>, davej@redhat.com,
       harlan@artselect.com, nickpiggin@yahoo.com.au, l_allegrucci@yahoo.it,
       linux-kernel@vger.kernel.org, mingo@elte.hu, suparna@in.ibm.com,
       jens.axboe@oracle.com
Subject: Re: SMP performance degradation with sysbench
References: <20070226223645.GA24174@redhat.com>	<98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>	<45E37EA3.3060101@redhat.com>	<20070227.130305.424251739.hyoshiok@miraclelinux.com>	<45E3B421.603@redhat.com> <20070227091409.6f3d12f9@werewolf-wl>
In-Reply-To: <20070227091409.6f3d12f9@werewolf-wl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> On Mon, 26 Feb 2007 23:31:29 -0500, Rik van Riel <riel@redhat.com> wrote:
> 
>> Hiro Yoshioka wrote:

>>> Another question. When the number of threads exceeds the number of
>>> CPU cores, we may get a lot of idle time. Then a workaround of
>>> MySQL is that do not creat threads which exceeds the number
>>> of CPU cores. Is it right?
>> Not really, that would make it impossible for MySQL to
>> handle more simultaneous database queries than the system
>> has CPUs.
>>
> 
> I don't know myqsl internals, but you assume one thread per query.
> If its more like Apache, one long living thread for several connections ?

Yes, they are longer lived client connections.  One thread
per connection, just like Apache.

> Its the same to answer 4+4 queries than 8 at half the speed, isn't it ?

That still doesn't fix the potential Linux problem that this
benchmark identified.

To clarify: I don't care as much about MySQL performance as
I care about identifying and fixing this potential bug in
Linux.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
