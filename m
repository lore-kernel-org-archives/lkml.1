Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXDDXsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXDDXsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbXDDXsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:48:45 -0400
Received: from gw.goop.org ([64.81.55.164]:38506 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbXDDXso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:48:44 -0400
Message-ID: <46143941.7050702@goop.org>
Date: Wed, 04 Apr 2007 16:48:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tglx@linutronix.de, johnstul@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, heiko.carstens@de.ibm.com
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
 tree
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>	 <1175417035.28263.42.camel@localhost.localdomain>	 <1175704712.15973.35.camel@imap.mvista.com>	 <20070404125853.1cf9b7b7.akpm@linux-foundation.org>	 <1175717425.15973.61.camel@imap.mvista.com>	 <20070404203647.GA12563@elte.hu>	 <1175719489.15973.66.camel@imap.mvista.com>	 <20070404211514.GA18600@elte.hu>	 <1175722246.15973.78.camel@imap.mvista.com>	 <20070404213404.GA21742@elte.hu> <1175723954.15973.96.camel@imap.mvista.com>
In-Reply-To: <1175723954.15973.96.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> I vaguely remember, but I don't think this creates a maintenance
> issue .. It's not related to maintenance , it's an issue of creating a
> new clocksource .. My perspective is that it has even less an effect
> than the CLOCK_SOURCE_IS_CONTINUOUS field .. People actually have to
> research that field, but list initialization is fairly clear.
>   

Yes, but its just make-work.  It has no bearing on what the clocksource
implementer needs to care about.  CLOCK_SOURCE_IS_CONTINUOUS is a
property of the clocksource they're implementing; it matters to them. 
But "list"?  It's just administration.

> The majority method for creating these clocksources is copy&paste, so
> I'm not sure nano argument on this subject particularly relevant ..

Great, so we end up with some random piece of clocksource internal
implementation detail cut-n-paste replicated all over the kernel.

    J
