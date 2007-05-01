Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXEAPx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXEAPx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbXEAPx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:53:56 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:8591 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652AbXEAPxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:53:55 -0400
Message-ID: <4637628E.2010106@interia.pl>
Date: Tue, 01 May 2007 17:53:50 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: Re: 2.6.21: longhaul freq-scaling broken
References: <46374BB6.9080703@web.de> <46375340.2010106@interia.pl> <6bffcb0e0705010805i62c987ecj4dde5e8365a95d16@mail.gmail.com>
In-Reply-To: <6bffcb0e0705010805i62c987ecj4dde5e8365a95d16@mail.gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EMID: adcb8acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Hi,
>> Hi
>> > the new longhaul driver of 2.6.21 is broken on my Via Eden board.
>> > Frequencies can no longer be switched by whatever governor.
>> > [...]
>> >
>> > I ported the longhaul driver from 2.6.20.7 to 2.6.21, it works fine.
>> Yes. My fault. Bug is known, but it was to late to include patch
>> fixing it in 2.6.21
>> > Yeah, I know there are only a few patches between both, but I would
>> like
>> > to reduce the test cycles to a minimum. Any suggestion where to look
>> > first is welcome therefore, ready-to-apply patches even more...
>> Longhaul ver. 2 support is the reason. First machine that was reported
>> not working is exactly like Your's: Samuel 2 600MHz. Patch reverting
>> changes is queued in cpufreq git. You can find it at
>> http://git.kernel.org/?p=linux/kernel/git/davej/cpufreq.git;a=commitdiff_plain;h=07844252ffd81ec192a62014bada1016c9703765
>>
> 
> Should it go to -stable?
If I understood Dave Jones correcly it is work in progress. 
> I have this on the list of known regressions already.
Can You send me more details? 
> Regards,
> Michal
Regards
Rafał

----------------------------------------------------------------------- Linda jako gospodyni domowa - zobacz!!!
>>> http://link.interia.pl/f1a79

