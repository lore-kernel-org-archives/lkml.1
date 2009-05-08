Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbZEHJec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbZEHJec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbZEHJeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:34:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53376 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753962AbZEHJeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:34:20 -0400
Date: Fri, 8 May 2009 10:31:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akataria@vmware.com
Cc: Chris Snook <chris.snook@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090508103125.00121311@lxorguk.ukuu.org.uk>
In-Reply-To: <1241734784.32495.31.camel@alok-dev1>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<1241560625.8665.17.camel@alok-dev1>
	<13a12eea0905070935o5abbeb49n8320d06c15b19b56@mail.gmail.com>
	<1241715373.32495.21.camel@alok-dev1>
	<13a12eea0905071329s79fb262tf89ed901a77726ae@mail.gmail.com>
	<20090507213403.3a75a6fb@lxorguk.ukuu.org.uk>
	<1241734784.32495.31.camel@alok-dev1>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As a side note Red Hat ships runtime configurable tick behaviour in RHEL
> > these days. HZ is fixed but the ticks can be bunched up. That was done as
> > a quick fix to keep stuff portable but its a lot more sensible than
> > randomly messing with the HZ value and its not much code either.
> > 
> Hi Alan, 
> 
> I guess you are talking about the tick_divider patch ? 
> And that's still same as reducing the HZ value only that it can be done
> dynamically (boot time), right ? 

Yes - which has the advantage that you can select different behaviours
rather than distributions having to build with HZ=1000 either for
compatibility or responsiveness can still allow users to drop to a lower
HZ value if doing stuff like HPC.

Basically it removes the need to argue about it at build time and lets
the user decide.
