Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZEODh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZEODh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbZEODhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:37:15 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:36056 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZEODhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:37:13 -0400
Date: Thu, 14 May 2009 23:36:49 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Janne Kulmala <janne.t.kulmala@tut.fi>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com
Subject: Re: [PATCH] ACPI: idle: fix init-time TSC check regression
In-reply-to: <alpine.LFD.2.00.0905150025030.3561@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0905142334090.24833@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com>
 <200905110226.50115.elendil@planet.nl>
 <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
 <4A0855A5.8040109@tut.fi>
 <alpine.LFD.2.00.0905141545280.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905141608070.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain>
 <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905150025030.3561@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		if (cx->valid)
> > +			tsc_check_state(cx->type);
> >  
> >  		if (cx->valid)
> >  			working++;
> 
> Could do with
> 
>       	 if (cx->valid) {
>             	tsc_check_state(cx->type);
>                 working++;
>       	 }

right, i deferred that to a cosmetic-only patch
that will also rename and move acpi_timer_check_state.

> Otherwise Acked-by: Thomas Gleixner <tglx@linutronix.de>

thanks,
Len Brown, Intel Open Source Technology Center
