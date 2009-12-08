Return-Path: <linux-kernel-owner+w=401wt.eu-S965842AbZLHTcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965842AbZLHTcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZLHTc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:32:27 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:55059 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756211AbZLHTc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:32:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4FAGcyHkuuWOw8/2dsb2JhbACBTNgahDIE
Date: Tue, 8 Dec 2009 14:32:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Jens Laas <jens.laas@data.slu.se>, Hans Liss <hans.liss@its.uu.se>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib-trie: code cleanup (v2)
Message-ID: <20091208193232.GE1653@Krystal>
References: <20091208184839.GA31383@Krystal> <20091208110916.386d8367@nehalam> <20091208192509.GD1653@Krystal> <20091208112813.42ca3cca@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091208112813.42ca3cca@nehalam>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:32:07 up 6 days, 10:22,  4 users,  load average: 0.01, 0.14,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Hemminger (shemminger@linux-foundation.org) wrote:
> On Tue, 8 Dec 2009 14:25:09 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Stephen Hemminger (shemminger@linux-foundation.org) wrote:
> > > On Tue, 8 Dec 2009 13:48:39 -0500
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > >  	/* use cache location of last found key */
> > > > -	if (iter->pos > 0 && pos >= iter->pos && (l = fib_find_node(t, iter->key)))
> > > > -		pos -= iter->pos;
> > > > +	if (iter->pos > 0 && pos >= iter->pos)
> > > > +		l = fib_find_node(t, iter->key);
> > > > +		if (l)
> > > > +			pos -= iter->pos;
> > > >  	else {
> > > 
> > > Missing bracket's here change the semantics.  
> > 
> > Ouch, yes. thanks.
> > 
> > 
> 
> The original code works and was clean enough, to split the assignment
> out would require duplicate code.

Yes, this is what I am figuring out at the moment. I'll leave it as is.

Mathieu

> 
> -- 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
