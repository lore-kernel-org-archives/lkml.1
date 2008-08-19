Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbYHSEA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbYHSEA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbYHSEAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:00:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39738 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbYHSEAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:00:19 -0400
Date: Tue, 19 Aug 2008 00:00:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
In-Reply-To: <20080819033618.GA24085@Krystal>
Message-ID: <alpine.DEB.1.10.0808182359290.13401@gandalf.stny.rr.com>
References: <48A9901B.1080900@redhat.com> <20080818154746.GA26835@Krystal> <48A9AFA7.8080508@freescale.com> <alpine.DEB.1.10.0808181425090.796@gandalf.stny.rr.com> <1219110814.8062.2.camel@pasglop> <alpine.DEB.1.10.0808182208110.13401@gandalf.stny.rr.com>
 <1219113549.8062.13.camel@pasglop> <alpine.DEB.1.10.0808182240330.13401@gandalf.stny.rr.com> <20080819024707.GA22659@Krystal> <alpine.DEB.1.10.0808182329220.13401@gandalf.stny.rr.com> <20080819033618.GA24085@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 18 Aug 2008, Mathieu Desnoyers wrote:
> > > > 
> > > 
> > > Argh. See text_poke(). It's there exactly for this purpose on x86.
> > 
> > Ouch, I just did. text_poke is quite heavy. It would be interesting to see 
> > that performed on 20,000 locations at one time. I could play with it, but 
> > I'm a bit nervous.
> > 
> 
> It's alread used to modify the LOCK prefixes in alternative.c and did
> not seem to be too slow for that.. it should therefore be ok.

There's a lot more functions than locks ;-)

Anyway, this is only needed after system boot up. But then we do it ever 
time we start or stop tracing. I'll try it out and see if it is noticable.

-- Steve

