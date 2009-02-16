Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbZBPIL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbZBPIL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZBPILV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:11:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37468
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbZBPILU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:11:20 -0500
Date: Mon, 16 Feb 2009 00:11:04 -0800 (PST)
Message-Id: <20090216.001104.233095882.davem@davemloft.net>
To: peterz@infradead.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: replace commatas with semicolons
From: David Miller <davem@davemloft.net>
In-Reply-To: <1234565983.4831.9.camel@laptop>
References: <alpine.LFD.2.00.0902132243480.3616@localhost.localdomain>
	<1234565983.4831.9.camel@laptop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 13 Feb 2009 23:59:43 +0100

> On Fri, 2009-02-13 at 22:46 +0100, Thomas Gleixner wrote:
> > Impact: syntax fix
> > 
> > Interestingly enough this compiles w/o any complaints:
> > 
> > 	orphans = percpu_counter_sum_positive(&tcp_orphan_count),
> > 	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated),
> 
> Yep, the wonders of the , operator. Look her up the next time you're
> reading the C specs and marvel :-)

"," has nothing on "sizeof(unsigned (long))" which is accepted
by C compilers too. :-)

