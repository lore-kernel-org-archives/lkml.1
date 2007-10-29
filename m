Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbXJ2Fpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbXJ2Fpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXJ2Fph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:45:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40670 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbXJ2Fpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:45:36 -0400
Date: Sun, 28 Oct 2007 22:45:33 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071028224533.df924291.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
	<20071028164637.8d1b45b0.pj@sgi.com>
	<alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
	<20071028212745.57a7db67.pj@sgi.com>
	<alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> If we can't identify any applications that would be broken by this, what's 
> the difference in simply implementing Choice B and then, if we hear 
> complaints, add your hack to revert back to Choice A behavior based on the 
> get_mempolicy() call you specified is always part of libnuma?

I'll probably reply to other parts of your message later, but this
one catches my eye right now.

"if we hear complaints, add your hack ... back"  -- this doesn't seem
like a good idea to me.  Maybe inside Google you don't see it, but
for those of us shipping computer systems using major distributions
such as SUSE or Red Hat, there can be a year lag between when I send a
feature patch to Andrew, and when my customers send their first
feedback to me resulting from using that new feature.

There are ways to expedite fixes for specific situations, of course,
but in general, this is rather like sending out a deep space probe.
You have to conservatively cover your options pre-launch, because
post-launch repairs are costly, slow and limited.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
