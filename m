Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYCQPnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYCQPnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYCQPnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:43:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65011 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYCQPnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:43:43 -0400
Date: Mon, 17 Mar 2008 11:43:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu, ego@in.ibm.com,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, akpm@linux-foundation.org, josh@freedesktop.org,
       tglx@linutronix.de, niv@us.ibm.com
Subject: Re: [PATCH] fix misplaced mb() in rcu_enter/exit_nohz()
In-Reply-To: <20080317055434.GI24652@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0803171142580.1810@gandalf.stny.rr.com>
References: <20080317010821.GA29875@linux.vnet.ibm.com>
 <200803171409.08148.nickpiggin@yahoo.com.au> <20080317055434.GI24652@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Mar 2008, Paul E. McKenney wrote:
> >
> > Can you make these smp_mb() as well?
>
> Can't see why not, now that you mention it.  Steve, anything Nick and
> I are missing here?  (See updated patch below.)

Not that I can see.

Acked-by: Steven Rostedt <srostedt@redhat.com>
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

-- Steve

