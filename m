Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYFWUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYFWUqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbYFWUqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:46:00 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44189 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754484AbYFWUp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:45:58 -0400
Date: Mon, 23 Jun 2008 13:45:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Petr Tesarik <ptesarik@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
In-Reply-To: <1214253593.11254.30.camel@twins>
Message-ID: <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> 
 <20080507073017.GJ32195@elte.hu>  <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com> 
 <1214241561.19392.21.camel@elijah.suse.cz> 
 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
 <1214253593.11254.30.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Peter Zijlstra wrote:

> > It is good that the locks are build with _trylock and _can_lock because 
> > then we can reenable interrupts while spinning.
> 
> Well, good and bad, the turn side is that fairness schemes like ticket
> locks are utterly defeated.

True. But maybe we can make these fairness schemes more generic so that 
they can go into core code?

