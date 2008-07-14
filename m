Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYGNPuC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYGNPuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:50:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYGNPty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:49:54 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39316 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753986AbYGNPtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:49:53 -0400
Message-ID: <487B759B.40700@sgi.com>
Date: Mon, 14 Jul 2008 08:49:47 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <20080712031736.GA3040@damson.getinternet.no>	<alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>	<b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>	<alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>	<alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <87vdz9ztt5.fsf@basil.nowhere.org>
In-Reply-To: <87vdz9ztt5.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> Btw - the way to avoid this whole problem might be to make CPU migration 
>> use a *different* CPU map than "online".
> 
> In general I think we need more such masks. Some time ago I had
> a patch to introduce cpu_ever_online_mask, which prevented some
> problems with accessing uninitialized per cpu data.

Not to divert the conversation too much but I would like to see these
maps allocated based on the real number of cpus and not NR_CPUS.

Thanks,
Mike
