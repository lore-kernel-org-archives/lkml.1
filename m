Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZHFPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZHFPh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZHFPh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:37:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44899 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZHFPh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:37:57 -0400
Date: Thu, 6 Aug 2009 08:37:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Menage <menage@google.com>, Benjamin Blum <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       oleg <oleg@redhat.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090806153756.GC6747@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com> <20090806095854.GD26446@hawkmoon.kerlabs.com> <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com> <1249554853.32113.145.camel@twins> <6599ad830908060342m1fc8cdd2me25af248a8e0e183@mail.gmail.com> <1249556540.32113.191.camel@twins> <6599ad830908060424r72e1aa12g2b246785e7bc039c@mail.gmail.com> <1249558761.32113.262.camel@twins> <20090806151922.GB6747@linux.vnet.ibm.com> <1249572286.32113.527.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249572286.32113.527.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 05:24:46PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-06 at 08:19 -0700, Paul E. McKenney wrote:
> > 
> > > So yes, putting a rwsem in there sounds fine, you're already bouncing
> > > it.
> > 
> > If the critical section is small, is an rwsem really better than a
> > straight mutex?
> 
> Well, my understanding was that it needed to surround much, if not all,
> of clone(). That's a rather large bit of code.

That would indeed justify an rwsem!  ;-)

							Thanx, Paul
