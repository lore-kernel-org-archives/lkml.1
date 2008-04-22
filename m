Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbYDVBOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbYDVBOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932450AbYDVBOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:14:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbYDVBOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:14:23 -0400
Date: Mon, 21 Apr 2008 21:14:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dwalker@mvista.com, sdietrich@novell.com, dvhltc@us.ibm.com,
       niv@us.ibm.com
Subject: Re: [PATCH] SELinux fixups needed for preemptable RCU from -rt
In-Reply-To: <20080422011233.GG9153@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0804212113590.27460@gandalf.stny.rr.com>
References: <20080422003412.GA9983@linux.vnet.ibm.com>
 <Pine.LNX.4.58.0804212053530.25185@gandalf.stny.rr.com>
 <20080422011233.GG9153@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Apr 2008, Paul E. McKenney wrote:

> On Mon, Apr 21, 2008 at 08:54:51PM -0400, Steven Rostedt wrote:
> >
> > On Mon, 21 Apr 2008, Paul E. McKenney wrote:
> > > @@ -807,8 +810,14 @@ int avc_ss_reset(u32 seqno)
> > >
> > >  	for (i = 0; i < AVC_CACHE_SLOTS; i++) {
> > >  		spin_lock_irqsave(&avc_cache.slots_lock[i], flag);
> > > +		/*
> > > +		 * On -rt the outer spinlock does not prevent RCU
> > > +		 * from being performed:
> >
> > I would suggest to change this comment to "With preemptible RCU" from
> > "On -rt".
>
> Good point...  How about the following?

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

