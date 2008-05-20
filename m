Return-Path: <linux-kernel-owner+w=401wt.eu-S1765725AbYETNyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765725AbYETNyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYETNyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:54:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYETNyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:54:08 -0400
Date: Tue, 20 May 2008 09:54:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: MA QING A <Qing.a.Ma@alcatel-sbell.com.cn>
cc: Kasper Sandberg <lkml@metanurb.dk>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: RE: 2.6.25.4-rt2
In-Reply-To: <630E9048ECEBBB4798CE33255209FE7306483561@CNSHGSMBS02.ad4.ad.alcatel.com>
Message-ID: <Pine.LNX.4.58.0805200945120.12041@gandalf.stny.rr.com>
References: <1211237032.14697.76.camel@localhost.localdomain><1211239147.198
 45.42.camel@localhost>   <Pine.LNX.4.58.0805191936120.4125@gandalf.stny.rr.com><630E9048ECEBBB4798CE
 33255209FE730648317D@CNSHGSMBS02.ad4.ad.alcatel.com> 
 <Pine.LNX.4.58.0805200030120.9319@gandalf.stny.rr.com>
 <630E9048ECEBBB4798CE33255209FE7306483561@CNSHGSMBS02.ad4.ad.alcatel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

[
  It seems that you may be new to the lists, so I will let you know,
  please do not top post. It is appropriate to either bottom post or
  better yet, inline reply. See http://en.wikipedia.org/wiki/Posting_style
]


On Tue, 20 May 2008, MA QING A wrote:

> Thanks very much for your explanation
> At the very beginning I thought the Hackbench was a latency tools, so
> I was very surprised to see such result.
>
> But there's another question. When I choose the Complete Preemption
> -Real Time  configuration, it's recommended to choose Timer Frequency
> ---> 1000Mhz to improve the cpu performance, does it mean cpu will cost
> much more during the thread context switch? Or I should choose 100Mhz in
> order to decrease the thread context switch and get a better
> performance?
>
> Which one should I choose? Or any useful tools can tell me the differences.
>

I'm not sure where you read that. With the introduction of high-resolution
timers, the HZ value isn't that important anymore. Things that might use
select or poll as timeouts will still be at the HZ frequency, but other
code that uses proper timer API will still react well.

Matters what you are doing. Try out different values yourself and see what
you find is the best. You can also report your findings if you want.

Cheers,

-- Steve

