Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbXFISIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbXFISIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXFISI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:08:29 -0400
Received: from www.osadl.org ([213.239.205.134]:36251 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753453AbXFISI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:08:28 -0400
Subject: Re: [1/3] 2.6.22-rc4: known regressions v2
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Rodrigo Luiz <troops.of.doom@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Gary Zambrano <zambrano@broadcom.com>, Michael Buesch <mb@bu3sch.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>
In-Reply-To: <466AE606.7020704@googlemail.com>
References: <466AE606.7020704@googlemail.com>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 20:08:22 +0200
Message-Id: <1181412502.4404.359.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-09 at 19:40 +0200, Michal Piotrowski wrote:
> Subject    : nanosleep(0) behaviour
> References : http://lkml.org/lkml/2007/5/27/108
>              http://lkml.org/lkml/2007/6/4/239
> Submitter  : Maximilian Engelhardt <maxi@daemonizer.de>
> Handled-By : Gary Zambrano <zambrano@broadcom.com>
>              Michael Buesch <mb@bu3sch.de>
>              Thomas Gleixner <tglx@linutronix.de>
> Status     : problem is being debugged

Please remove this. The behavior is correct and it just affects buggy
applications like iperf, which used usleep(0) as a yield. iperf is fixed
by now.

	tglx


