Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYGHA3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYGHA3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 20:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYGHA3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 20:29:34 -0400
Received: from ozlabs.org ([203.10.76.45]:40931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbYGHA3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 20:29:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 0/4] Paravirtual spinlocks
Date: Tue, 8 Jul 2008 10:29:18 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Jens Axboe <axboe@kernel.dk>,
       Xen devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Friebel <thomas.friebel@amd.com>, Ingo Molnar <mingo@elte.hu>
References: <20080707190749.299430659@goop.org>
In-Reply-To: <20080707190749.299430659@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081029.19242.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 05:07:49 Jeremy Fitzhardinge wrote:
> At the most recent Xen Summit, Thomas Friebel presented a paper
> ("Preventing Guests from Spinning Around",
> http://xen.org/files/xensummitboston08/LHP.pdf) investigating the
> interactions between spinlocks and virtual machines.  Specifically, he
> looked at what happens when a lock-holding VCPU gets involuntarily
> preempted.

I find it interesting that gang scheduling the guest was not suggested as an 
obvious solution.

Anyway, concept looks fine; lguest's solution is more elegant of course :)

A little disappointing that you can't patch your version inline.

Cheers,
Rusty.
