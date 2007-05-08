Return-Path: <linux-kernel-owner+w=401wt.eu-S934864AbXEHJu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934864AbXEHJu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934845AbXEHJu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:50:28 -0400
Received: from www.osadl.org ([213.239.205.134]:45529 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934817AbXEHJu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:50:27 -0400
Subject: Re: [PATCH 4/5] i386: i8253 clockevent shutdown and unused using
	pit
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joachim Deguara <joachim.deguara@amd.com>
In-Reply-To: <20070508094628.GW3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
	 <1178556361.3042.16.camel@localhost.localdomain>
	 <20070508093957.GS3505@sequoia.sous-sol.org>
	 <20070508094628.GW3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 11:53:14 +0200
Message-Id: <1178617994.3042.312.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 02:46 -0700, Chris Wright wrote:
> Disable by programming pit directly when performing CLOCK_EVT_MODE_UNUSED
> or CLOCK_EVT_MODE_SHUTDOWN transitions.  (A variant) tested successfully
> by Joachim Deguara on a Geode that exhibited BZ 8027 behaviour (with
> bad bogomips).

Sigh, we had problems with that one on Ingo's Vaio-of-fun-emulator
laptop. That's why I did the irq disable.

Ingo, can you please retest ?

	tglx


