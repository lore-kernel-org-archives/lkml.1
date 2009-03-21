Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZCUS7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZCUS7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 14:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZCUS6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 14:58:51 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39715 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZCUS6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 14:58:49 -0400
Date: Sat, 21 Mar 2009 11:58:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: dipankar@in.ibm.com, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090321185846.GB7148@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090319085628.GA6167@in.ibm.com> <20090319071841.63334eff@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org> <20090320044541.GE6807@linux.vnet.ibm.com> <20090320065058.65d01771@infradead.org> <20090320143104.GA6698@linux.vnet.ibm.com> <20090320111354.679ab53d@infradead.org> <20090321012746.GM6698@linux.vnet.ibm.com> <20090320215825.19b8baae@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320215825.19b8baae@infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:58:25PM -0700, Arjan van de Ven wrote:
> On Fri, 20 Mar 2009 18:27:46 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > I've seen only this (input) one to take a long time
> > 
> > Ouch!!!  A -single- synchronize_rcu() taking a full second???  That
> > indicates breakage.
> 
> I'll do a debug mode tomorrow and visualize it as part of the bootgraph;
> hopefully it'll be an interesting result.
> I'll share the graph when I have it....

Looking forward to seeing it!!!

							Thanx, Paul
