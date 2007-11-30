Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbXK3KeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbXK3KeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 05:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbXK3KeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 05:34:10 -0500
Received: from ns.suse.de ([195.135.220.2]:60087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXK3KeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 05:34:08 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Metzger, Markus T" <markus.t.metzger@intel.com>, tglx@linutronix.de
Subject: Re: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Date: Fri, 30 Nov 2007 11:34:03 +0100
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Michael Kerrisk" <mtk-manpages@gmx.net>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071129155940.7df70ac2.akpm@linux-foundation.org> <029E5BE7F699594398CA44E3DDF5544401051EEF@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF5544401051EEF@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301134.04719.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 10:57:22 Metzger, Markus T wrote:
> 
> >Is there any userspace code avaialble which people can use to play with
> >this?
> 
> Not yet. We are talking to internal teams regarding gdb support.

But you already have reasonably realistic test code right?

We were burned a few times recently with new interfaces that turned
out to be not really usable from the user perspective.

Ideal situation to avoid that would be that at least one person other than 
the patch submitter has successfully written a program using it first.

e.g. I'm still feeling a bit uneasy about that global sysctl
embedded in the interface.

> 
> >How do you envisage it being used in the long term?  Do you 
> >expect any of
> >the standard performance tuning tools will be tweaked to 
> >understand this
> >feature and if so which ones?
> 
> I would expect debuggers to use it to show an execution trace of the 
> debuggee. The ptrace interface targets application debuggers;

application debuggers and possible performance tools. There are certainly
a lot of possibilities from this.


> If the feature turns out to be really useful, I would, of course, expect
> (or at least hope) that other CPU's would provide a similar feature.

I think some others do. But the details are always CPU specific. I doubt
much low level code will be possible to share. But it would be good
if the ptrace interface is generic enough for everybody (I think it was
though) 

 
> Most of the code is arch specific. If other CPU's share the general BTS
> layout,
> some of the ptrace_bts.c code could be shared.
> Since the implementation only supports x86, I think the code should go
> into
> arch/x86 - at least until other CPU's are supported.

Agreed.

-Andi
