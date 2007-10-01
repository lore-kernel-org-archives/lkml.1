Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbXJAWZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbXJAWZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXJAWYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:24:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56915 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXJAWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:24:53 -0400
Date: Mon, 1 Oct 2007 15:24:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20071001222449.GA11367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070926151351.GA328@tv-sign.ru> <20070927154652.GE16652@linux.vnet.ibm.com> <20070928144714.GA397@tv-sign.ru> <20070928185759.GC9153@linux.vnet.ibm.com> <20070930163102.GA374@tv-sign.ru> <Pine.LNX.4.64.0709301549160.19355@alien.or.mcafeemobile.com> <20071001013739.GB12494@linux.vnet.ibm.com> <Pine.LNX.4.64.0710011129440.25942@alien.or.mcafeemobile.com> <20071001192136.GC29100@linux.vnet.ibm.com> <Pine.LNX.4.64.0710011249390.25942@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710011249390.25942@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 03:09:16PM -0700, Davide Libenzi wrote:
> On Mon, 1 Oct 2007, Paul E. McKenney wrote:
> 
> > That would indeed be one approach that CPU designers could take to
> > avoid being careless or sadistic.  ;-)
> 
> That'd be the easier (unique maybe) approach too for them, from an silicon 
> complexity POV. Distinguishing between different CPUs stores once inside a 
> shared store buffer, would require tagging them in some way. That'd defeat 
> most of the pros of having a shared store buffer ;)

Tagging requires but one bit per entry.  Depends on the workload -- if
lots of barriers, bursty stores and little sharing, tagging might win.
If lots of sharing, then your suggested approach might win.

						Thanx, Paul
