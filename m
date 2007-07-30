Return-Path: <linux-kernel-owner+w=401wt.eu-S968561AbXG3Vnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968561AbXG3Vnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967202AbXG3Vni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:43:38 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:52434 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765728AbXG3Vnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:43:37 -0400
Subject: Re: +
	numa-generic-management-of-nodemasks-for-various-purposes.patch added to
	-mm tree
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, bob.picco@hp.com, clameter@sgi.com
In-Reply-To: <20070729045951.55b2285b.pj@sgi.com>
References: <200707290715.l6T7FtN8013215@imap1.linux-foundation.org>
	 <20070729045951.55b2285b.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 30 Jul 2007 17:43:47 -0400
Message-Id: <1185831827.5492.112.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 04:59 -0700, Paul Jackson wrote:
> Lee Schermerhorn (via Andrew) wrote:
> > +static inline void node_set_state(int node, enum node_states state)
> > +{
> > +	__node_set(node, &node_states[state]);
> > +}
> > +
> > +static inline void node_clear_state(int node, enum node_states state)
> > +{
> > +	__node_clear(node, &node_states[state]);
> > +}
> 
> 
> Lee - would you get the same result (same compiled binary code) with
> something like:
> 
> +static inline void node_set_state(int node, enum node_states state)
> +{
> +	node_set(node, node_states[state]);
> +}
> +
> +static inline void node_clear_state(int node, enum node_states state)
> +{
> +	node_clear(node, node_states[state]);
> +}
> 
> If so, then I're prefer the latter, as it doesn't depend on the strange
> #define wrapping an inline implementation of node_set and node_clear.
> 
> In other words, the latter looks 'simpler'.
> 

I'm OK with this, altho' I think Christoph was just following the lead
of the other node[s]_*() functions.  Care to submit a patch when you
return from vacation?

Christoph:  what do you think?

Lee

