Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYHLKcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYHLKcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 06:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYHLKcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 06:32:33 -0400
Received: from nhobbit.corpit.ru ([81.13.33.150]:23669 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYHLKcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 06:32:32 -0400
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 06:32:32 EDT
Message-ID: <48A16439.8050309@msgid.tls.msk.ru>
Date: Tue, 12 Aug 2008 14:21:45 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: random stalls on certain hardware - regression?
References: <4873E27C.6050504@msgid.tls.msk.ru> <20080709163618.GA5462@joi> <4875B497.7060309@msgid.tls.msk.ru>
In-Reply-To: <4875B497.7060309@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote at Thu, 10 Jul 2008 11:04:55 +0400:

[almost a month-ago email/thread...]

> Marcin Slusarz wrote:
>> On Wed, Jul 09, 2008 at 01:56:12AM +0400, Michael Tokarev wrote:
> 
> [random complete hangs on 2.6.25 but not 2.6.24]
> 
>> Definitely try 2.6.26-rc9 (which will soon become 2.6.26, so people will
> 
> Ok, tried 2.6.26-rc9 today night - after disabling some drivers which
> were not compilable and fixing some places in core code.  It does the
> same thing - i.e. it locks up the same way as 2.6.25 did, and locks up
> hard as before (no keyboard and network working).

Ok, I finally tried current 2.6.26 [.2] on this same machine, -- it's
up and running since last Friday, so almost 4 days already, and it works
so far, no lock-ups for now.  2.6.26-pre definitely didn't work - max
uptime was ~12 hours.  I can't say the problem has been fixed for sure,
maybe it's just a {bad|good} luck, will see how it will work in next days.

And btw, nmi-watchdog didn't help, -- with it enabled, the machine locked
up the same way as before -- completely silent, nothing's on the screen etc.
(And no, it's not a hardware problem, since all kernels up to 2.6.24 works
just fine, under any loads.  Or should not be hardware, anyway)

/mjt
