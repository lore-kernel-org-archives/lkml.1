Return-Path: <linux-kernel-owner+w=401wt.eu-S966473AbXEHKcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966473AbXEHKcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966352AbXEHKb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:31:57 -0400
Received: from www.osadl.org ([213.239.205.134]:53422 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966301AbXEHKb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:31:56 -0400
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
In-Reply-To: <20070508100657.GZ3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
	 <1178556361.3042.16.camel@localhost.localdomain>
	 <20070508093957.GS3505@sequoia.sous-sol.org>
	 <1178617864.3042.309.camel@localhost.localdomain>
	 <20070508095130.GY3505@sequoia.sous-sol.org>
	 <1178618304.3042.320.camel@localhost.localdomain>
	 <20070508100657.GZ3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 12:34:42 +0200
Message-Id: <1178620482.3042.323.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 03:06 -0700, Chris Wright wrote:

> Tick Device: mode:     0
> Clock Event Device: hpet
>  max_delta_ns:   85899346200
>  min_delta_ns:   1920
>  mult:           107374182
>  shift:          32
>  mode:           2
>  next_event:     9223372036854775807 nsecs
>  set_next_event: hpet_next_event
>  set_mode:       hpet_set_mode
>  event_handler:  tick_handle_periodic_broadcast
> tick_broadcast_mask: 00000001

Broadcasting is active. The system has C2 state, right ?

If it's not AMD you can add lapic_timer_c2_ok to the commandline.

	tglx


