Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYGOImt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYGOImt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYGOImk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:42:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58793 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbYGOImi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:42:38 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5338"; a="4545879"
Message-ID: <487C62FB.6030304@qualcomm.com>
Date: Tue, 15 Jul 2008 01:42:35 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org> <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com> <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org> <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com> <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org> <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com> <487C1374.8020404@qualcomm.com> <alpine.LFD.1.10.0807142104250.3017@woody.linux-foundation.org> <20080715083223.GA2600@elte.hu>
In-Reply-To: <20080715083223.GA2600@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Mon, 14 Jul 2008, Max Krasnyansky wrote:
>>> Did you guys an updated patch ? Dmitry pointed out several things that Linus
>>> missed in his original version. I guess I can go through the thread and
>>> reconstruct that but if you have a patch I can try let me know.
>> I didn't update it, and right now I'm just merging too much (and 
>> discussing the merges) to have time.
>>
>> The patch really needs to have some scheduler person look at the use 
>> fo cpu_active_map - I was kind of hoping that Ingo would.
> 
> yeah - it's very high on our TODO list :-) Peter, Dmitry and me are 
> looking into it.
> 
> I didnt touch most of -tip in the past few days to get a rock solid QA 
> track record for all items we have.

I just sent you guys a patch. Please take a look. I've probably missed something
but it should close (I think). Also we'd probably at least want the bits that
streamline the domain reinitialization because it helps with cpusets (ie uses
same exact path for all cases).

Max
