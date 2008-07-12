Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYGLXZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYGLXZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYGLXZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:25:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:4902 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYGLXZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o9XDMGSGopaRUEcad5RU+1z874h5Vq2CscUEi997yYnLptnhI1argLa/f7A2Kwn1+I
         EpC0BB1lKQw4M437hQc1IcChUEs3hQtQStHM8px8GAUU+Ci0njslst9yB1RLEIGJbtrR
         Ctvhz1nhiDTsgN+Fp3cvJC5IVR9aKttOgCZSI=
Message-ID: <19f34abd0807121625o81ad509g34cbce77d9e2a302@mail.gmail.com>
Date: Sun, 13 Jul 2008 01:25:02 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
	 <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
	 <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 1:05 AM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> Are you sure that you have removed my patch or the one from Miao? I
> would be really surprised if this patch works without them. Linus has
> updated sched_migrate_task() which is used _only_ by sched_exec() ---
> this is not the path that leads to this bug. try_to_wake_up() -> ...
> -> wake_idle() does not see "cpu_active_map".

Absolutely. I could have made an error somewhere along the way, of
course (yes, it does happen), but I am quite sure I did everything
correctly.

If you doubt it, you could try it too. All that is needed to reproduce
the original BUG here is CPUSETS=y and bring cpu1 down.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
