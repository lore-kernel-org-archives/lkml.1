Return-Path: <linux-kernel-owner+w=401wt.eu-S1764109AbXFKFVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764109AbXFKFVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 01:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbXFKFVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 01:21:08 -0400
Received: from www.osadl.org ([213.239.205.134]:42720 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753630AbXFKFVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 01:21:05 -0400
Subject: Re: [patch-mm 01/23] NOHZ: Fix ARM,SH,SPARC64 idle nohz handling
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>, Adam Belay <abelay@novell.com>,
       Len Brown <lenb@kernel.org>, Dave Miller <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>
In-Reply-To: <20070611002614.GA20676@linux-sh.org>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <20070610092446.402212606@inhelltoy.tec.linutronix.de>
	 <20070611002614.GA20676@linux-sh.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 07:20:59 +0200
Message-Id: <1181539259.8176.40.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 09:26 +0900, Paul Mundt wrote:
>
> There are two paths here depending on hlt/nohlt setting, we need to have
> tick_nohz_stop_sched_tick() for the TIF_POLLING_NRFLAG case, too.

Do you really want to run through that in every loop iteration ? If you
have nohlt, then nohz is rather pointless.

	tglx


