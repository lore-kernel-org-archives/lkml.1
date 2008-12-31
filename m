Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYLaJuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYLaJuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYLaJt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:49:59 -0500
Received: from mx02.mailboxcop.com ([206.125.223.72]:53087 "EHLO
	mx02.mailboxcop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYLaJt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:49:59 -0500
Message-ID: <495B40C1.4080305@jaysonking.com>
Date: Wed, 31 Dec 2008 03:52:01 -0600
From: Jayson King <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       shaggy@linux.vnet.ibm.com, rjw@sisk.pl, fabio.comolli@gmail.com
Subject: Disregard: was Re: large intermittent latency spike 2.6.28 (and 2.6.27.10),
 bisect commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325 -> Revert "sched_clock:
 prevent scd->clock from moving backwards"
References: <495A96FF.1000200@jaysonking.com>
In-Reply-To: <495A96FF.1000200@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Canit-CHI2: 0.50
X-Bayes-Prob: 0.9999 (Score 4, tokens from: @@RPTN, outgoing)
X-Spam-Score: 4.10 (****) [Hold at 5.20] RDNS_NONE,2(1.2),6947(-1.2),Bayes(0.9999,4.0)
X-CanItPRO-Stream: outgoing (inherits from default)
X-Canit-Stats-ID: 333250006 - a7a05fccb0eb
X-Antispam-Training-Forget: http://mailboxcop.com/canit/b.php?i=333250006&m=a7a05fccb0eb&c=f
X-Antispam-Training-Nonspam: http://mailboxcop.com/canit/b.php?i=333250006&m=a7a05fccb0eb&c=n
X-Antispam-Training-Spam: http://mailboxcop.com/canit/b.php?i=333250006&m=a7a05fccb0eb&c=s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I noticed large latency spikes in 2.6.28 (and 2.6.27.10) which would 
> make the system unresponsive for minutes at a time (alt+Fn switching 
> wouldn't even work) when the system is under load. I could trigger the 
> latency by running a large make -j 3. Sometimes it would trigger in a 
> few seconds other times it would take a few minutes.
>
> I bisected it in 2.6.27.10 to d9a888b061f55534016d2d86a21639948312a117 
> -> Revert "sched_clock: prevent scd->clock from moving backwards" 
> (ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325 in 2.6.28) and reverting it 
> in 2.6.28 make the latency spike go away. At least, so far no spike in 
> over 24 hours.
Please disregard this. I just had a latency spike again, so this is not 
the change I'm looking for... I'll need to look for what is causing it 
again, apparently not only the make -j 3 I thought, and do another test.

Jayson

