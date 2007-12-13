Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbXLMMxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbXLMMxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 07:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbXLMMxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 07:53:40 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:34144 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXLMMxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 07:53:39 -0500
Date: Thu, 13 Dec 2007 07:52:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       benh@kernel.crashing.org, dino@in.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, antonb@us.ibm.com
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
In-Reply-To: <20071213061029.GB25047@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0712130748230.27141@gandalf.stny.rr.com>
References: <20071029185044.GA23413@linux.vnet.ibm.com>
 <Pine.LNX.4.58.0712122253390.19475@gandalf.stny.rr.com>
 <20071213061029.GB25047@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Dec 2007, Paul E. McKenney wrote:

> >
> > I'm pulling your patch for the above added code. Took me a few hours to
> > find the culprit, but I was getting scheduling in atomic bugs. Turns out
> > that this code you put "preempt_disable" in calls sleeping spinlocks.
> >
> > Might want to run with DEBUG_PREEMPT.
>
> I thought that you had already pulled the above version...
>
> Here is the replacement that I posted on November 9th (with much help
> from Ben H):
>
> http://lkml.org/lkml/2007/11/9/114

OK, sorry, I somehow got the two reversed, and I think I replaced the new
one with the old one :-(

I blame the expresso!

>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

OK, will apply to -rt14

Thanks,

-- Steve
