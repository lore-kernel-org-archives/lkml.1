Return-Path: <linux-kernel-owner+w=401wt.eu-S934846AbXEHJsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934846AbXEHJsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934845AbXEHJsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:48:19 -0400
Received: from www.osadl.org ([213.239.205.134]:45496 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934841AbXEHJsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:48:17 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070508093957.GS3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
	 <1178556361.3042.16.camel@localhost.localdomain>
	 <20070508093957.GS3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 11:51:03 +0200
Message-Id: <1178617864.3042.309.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 02:39 -0700, Chris Wright wrote:

> OK, looks very similar all things considered.  One thing I didn't do
> was fix lapic timer calibration (was hoping you'd do that part, and you
> did ;-)  I've noticed that something has changed and I'm seeing irq0
> handled on cpu3 (4 cpu system), where it used to be on cpu0 as expected.

Strange, irq balancing ?

> In addition lapic timer is firing there, and I'm seeing a higher
> interrupt load than I used to.  This is the same in your set and mine.

Is irq0 _and_ the lapic timer firing ?

	tglx


