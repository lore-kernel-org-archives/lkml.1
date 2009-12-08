Return-Path: <linux-kernel-owner+w=401wt.eu-S965846AbZLHT2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965846AbZLHT2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbZLHT2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:28:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123AbZLHT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:28:40 -0500
Date: Tue, 8 Dec 2009 11:28:13 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "David S. Miller" <davem@davemloft.net>,
       Robert Olsson <robert.olsson@its.uu.se>,
       Jens Laas <jens.laas@data.slu.se>, Hans Liss <hans.liss@its.uu.se>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib-trie: code cleanup (v2)
Message-ID: <20091208112813.42ca3cca@nehalam>
In-Reply-To: <20091208192509.GD1653@Krystal>
References: <20091208184839.GA31383@Krystal>
	<20091208110916.386d8367@nehalam>
	<20091208192509.GD1653@Krystal>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009 14:25:09 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Stephen Hemminger (shemminger@linux-foundation.org) wrote:
> > On Tue, 8 Dec 2009 13:48:39 -0500
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > >  	/* use cache location of last found key */
> > > -	if (iter->pos > 0 && pos >= iter->pos && (l = fib_find_node(t, iter->key)))
> > > -		pos -= iter->pos;
> > > +	if (iter->pos > 0 && pos >= iter->pos)
> > > +		l = fib_find_node(t, iter->key);
> > > +		if (l)
> > > +			pos -= iter->pos;
> > >  	else {
> > 
> > Missing bracket's here change the semantics.  
> 
> Ouch, yes. thanks.
> 
> 

The original code works and was clean enough, to split the assignment
out would require duplicate code.

-- 
