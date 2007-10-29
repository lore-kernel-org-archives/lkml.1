Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbXJ2Xp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbXJ2Xp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXJ2Xpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:45:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54064 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754465AbXJ2Xpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:45:43 -0400
Date: Mon, 29 Oct 2007 16:45:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>
Subject: Re: [RFC] Create instrumentation directory (git repository)
In-Reply-To: <20071029234012.GB19413@Krystal>
Message-ID: <Pine.LNX.4.64.0710291643510.5039@schroedinger.engr.sgi.com>
References: <20071029215138.GA4233@Krystal> <Pine.LNX.4.64.0710291619210.4821@schroedinger.engr.sgi.com>
 <20071029234012.GB19413@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Mathieu Desnoyers wrote:

> * Christoph Lameter (clameter@sgi.com) wrote:
> > On Mon, 29 Oct 2007, Mathieu Desnoyers wrote:
> > 
> > > vm/vmstat.c
> > 
> > The vm statistics are important for the operation of the VM. They are not 
> > optional. So I do not think that they fall under the category of 
> > instrumentation.
> 
> But I guess vm stats can be useful to others; a kernel tracer for
> instance ?

Yes.

> Putting stuff in instrumentation/ by no way means that it becomes
> optional for a subsystem, but merely that it could either export
> information useful for kernel instrumentation or have some
> infrastructure parts merged with others. 

The vm statistics are intricately connected with other mm code. Best leave 
it where it is. The other instrumentation is something that is put in 
particularly for gaining statistics.



