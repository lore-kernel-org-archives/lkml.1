Return-Path: <linux-kernel-owner+w=401wt.eu-S2992994AbXDRSgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992994AbXDRSgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 14:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992995AbXDRSgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 14:36:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:18356 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992994AbXDRSgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 14:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=nDrRKXGTLRXeOEkgy+TFUfpobipb/Uc5qF7MVl8iGVpDoxEDopEe3sYpmMPCG8Qyh0h0u41W0YltBhItYBrJ3MS9GMSsuApNIParJHX+svbahbWKdfDf67XB/OTiIn+fblG3RHb6b6JsCtyaPHdIlKNeQmRriDugpW1XZ4Ch2rY=
Date: Wed, 18 Apr 2007 20:36:12 +0200
From: Diego Calleja <diegocg@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
Message-Id: <20070418203612.b4027575.diegocg@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
References: <20070417060955.GO8915@holomorphy.com>
	<20070417061503.GC1057@wotan.suse.de>
	<20070417062621.GL2986@holomorphy.com>
	<20070417070155.GF1057@wotan.suse.de>
	<20070417213954.GE11166@waste.org>
	<20070418031511.GA18452@wotan.suse.de>
	<20070418043831.GR11115@waste.org>
	<20070418050024.GF18452@wotan.suse.de>
	<20070418055525.GS11115@waste.org>
	<alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
	<20070418152355.GU11115@waste.org>
	<alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 18 Apr 2007 10:22:59 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> escribió:

> So if you have 2 users on a machine running CPU hogs, you should *first* 
> try to be fair among users. If one user then runs 5 programs, and the 
> other one runs just 1, then the *one* program should get 50% of the CPU 
> time (the users fair share), and the five programs should get 10% of CPU 
> time each. And if one of them uses two threads, each thread should get 5%.


"Fairness between users" was implemented long time ago by rik van riel
(http://surriel.com/patches/2.4/2.4.19-fairsched). Some people has been
asking for a functionality like that for a long time, ie: universities that want
to avoid gcc processes from one student that is trying to learn how fork()
works from starving the processes of rest of the students.

But not only they want "fairness between users", they also want "priorities
between users and/or groups of users", ie: "the 'students' group shouldn't
starve the 'admins' group".
