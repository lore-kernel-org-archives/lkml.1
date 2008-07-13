Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYGMP3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYGMP3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYGMP3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:29:30 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:45518 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYGMP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:29:29 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Max Krasnyansky <maxk@qualcomm.com>,
       Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
From: Andi Kleen <andi@firstfloor.org>
References: <20080712031736.GA3040@damson.getinternet.no>
	<alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	<b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	<alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
Date: Sun, 13 Jul 2008 17:29:26 +0200
In-Reply-To: <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> (Linus Torvalds's message of "Sat, 12 Jul 2008 14:30:33 -0700 (PDT)")
Message-ID: <87vdz9ztt5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jul 2008 15:22:00.0582 (UTC) FILETIME=[323D2A60:01C8E4FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> Btw - the way to avoid this whole problem might be to make CPU migration 
> use a *different* CPU map than "online".

In general I think we need more such masks. Some time ago I had
a patch to introduce cpu_ever_online_mask, which prevented some
problems with accessing uninitialized per cpu data.

-Andi
