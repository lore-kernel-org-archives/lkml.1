Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbYJMUYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbYJMUYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbYJMUXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:23:51 -0400
Received: from www.tglx.de ([62.245.132.106]:58508 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757714AbYJMUXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:23:50 -0400
Date: Mon, 13 Oct 2008 22:23:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: rt-users <linux-rt-users@vger.kernel.org>
cc: Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <ce@ceag.ch>, LKML <linux-kernel@vger.kernel.org>
Subject: New rt-tests maintainer
Message-ID: <alpine.LFD.2.00.0810132138540.15664@apollo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I'm handing over the maintainership of rt-tests (cyclictest,
signaltest, pi_stress) to Clark Williams.

rt-tests started with cyclictest, a test program I wrote for
validating the high resolution timers implementation. In hindsight I'm
still surprised that cyclictest became a defacto standard for
benchmarking preempt-rt, but on the technical side it's quite clear as
it tests the whole chain: interrupt -> wakeup -> scheduler ->
userspace.

I never expected that cyclictest might ship with distros and I'm very
grateful to all the people who contributed and helped to bring it and
the whole rt-tests package into shape. I know that I'm a lousy user
space programmer :)

@Clark, thanks for taking over. It takes away my permanent guilty
conscience of not caring about rt-tests enough.

@all, please support Clark with his new project as you supported
me. Thanks for all the support and help again !

Thanks,

	tglx

P.S.: If you really need to add autocrap^H^H^H^Htools please do it in
      a way so I still can hack on it :)
