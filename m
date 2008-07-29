Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYG2Ru5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYG2Ru5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbYG2Rut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:50:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60212 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbYG2Rus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:50:48 -0400
Date: Tue, 29 Jul 2008 19:50:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Ingo Molnar <mingo@elte.hu>, jblunck@suse.de
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000002
Message-ID: <20080729175043.GA11196@one.firstfloor.org>
References: <20080725095317.GA12636@skywalker> <20080728222643.GA6339@slug> <1217305335.5553.3.camel@marge.simson.net> <20080729120911.GI30344@one.firstfloor.org> <20080729065635.27630e33@infradead.org> <20080729145348.GN30344@one.firstfloor.org> <20080729083029.094a32cb@infradead.org> <20080729163113.GP30344@one.firstfloor.org> <20080729102251.22ac8543@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729102251.22ac8543@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's not what datacenter people say. As long as power gain is bigger
> than performance loss.. they tend to want it.

That's a special case. It's fine but they should explicitely configure it.
I suspect even the data center people prefer "opt in" versus "opt out" here.

> Also "significantly" is extremely subjective, like in this case it can
> be a win or a loss, depending.

My impression is that the losses are more likely than the wins here.
> 
> > When the user says impacting performance
> > is ok then doing that is fine of course, but not by default.
> 
> that's a fine kernel policy.
> 
> Distros will override this policy if their users tell them they're
> willing to do the tradeoff.. they will pick that default. In fact..
> that's a big part of their job.. 

I'm not fully convinced that was done intentionally in this case.
If there's an explicit setting somewhere that's fine anyways, but I think
here it more looks like a mistake.

-Andi
