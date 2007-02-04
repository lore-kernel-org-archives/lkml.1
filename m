Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXBDDYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXBDDYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 22:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXBDDYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 22:24:08 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:64492 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751998AbXBDDYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 22:24:07 -0500
Date: Sat, 3 Feb 2007 22:24:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
In-Reply-To: <20070204002338.GB5647@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0702032220560.17500-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Paul E. McKenney wrote:

> > And another note: this all assumes that STORE-MB-LOAD works "correctly", yes?
> > We have other code which relies on that, should not be a problem.
> 
> We have been working with Doug Lea of SUNY Oswego, Sebatian Burckhardt of
> University of Pennsylvania, and Vijay Saraswat of IBM Research towards
> a "universal memory model" that accommodates all machines.  Currently,
> it does in fact handle store-mb-load the way we all want, thankfully!

We should add that many places in the kernel do depend on proper behavior 
for this data access pattern.  So whatever "universal memory model" we end 
up with, it had better handle the pattern correctly if Linux is to support 
it.

It's interesting to note, however, that this does exclude simple MESI.

Alan Stern

