Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624Ab0AZOH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0AZOH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512Ab0AZOH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:07:26 -0500
Received: from [80.120.171.167] ([80.120.171.167]:14495 "EHLO
	merlin.merlin.local" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828Ab0AZOHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:07:25 -0500
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 09:07:25 EST
Message-ID: <4B5EF717.7010707@reinelt.co.at>
Date: Tue, 26 Jan 2010 15:07:19 +0100
From: Michael Reinelt <michael@reinelt.co.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.0.7) Gecko/20061013 Thunderbird/1.5.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Roman Jarosz <kedgedev@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       A Rojas <nqn1976list@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, jcnengel@googlemail.com,
       rientjes@google.com, earny@net4u.de,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
References: <20100126141055.5AAD.A69D9226@jp.fujitsu.com> <op.u64t84zuasvm2a@kedge> <20100126183412.6AC9.A69D9226@jp.fujitsu.com> <89k77n$mrr1hi@fmsmga001.fm.intel.com> <2f11576a1001260503o5f987512n3c39ae1c3caa43f3@mail.gmail.com> <89khjo$egh4fr@orsmga002.jf.intel.com> <4B5EF55A.5080602@reinelt.co.at>
In-Reply-To: <4B5EF55A.5080602@reinelt.co.at>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Michael Reinelt schrieb:
> 
> Chris Wilson schrieb:
>> On Tue, 26 Jan 2010 22:03:06 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>> Please consider to revert such commit at once. Lots people reported
>>> the same issue.
>>> I really hope to stop bug report storm.
>> Your CC did not reference the problem that you were discussing, nor that
>> it is even easier to trigger an OOM without the shrinker. Memory
>> exhaustion due to the excess usage of surfaces from userspace is not a new
>> issuer. So what is the problem you have encountered and how does running
>> the OOM killer earlier fix the issue of triggering the OOM killer?
>>
> 
> To end this discussion: I just had a OOM with the GEM / shmem partial revert patch from Motohiro :-(
> 
> Unfortunately without Motohiro's oom-debug patch applied :-(
> 
> as a non-git-user I have to manually patch memory.c, but I hope I can get things right. I will provide results ASAP.

Sorry sorry sorry... false alarm. One should also *install* a new kernel after compiling...

I'll give it another try, this time with OOM debugging applied.


sorry for the noise...

-- 
Michael Reinelt <michael@reinelt.co.at>
http://home.pages.at/reinelt
GPG-Key 0xDF13BA50
ICQ #288386781
