Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZHFPZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZHFPZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZHFPZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:25:06 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:62579 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbZHFPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:25:04 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
 tgid at once
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Benjamin Blum <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       oleg <oleg@redhat.com>
In-Reply-To: <20090806151922.GB6747@linux.vnet.ibm.com>
References: <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
	 <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
	 <1249554853.32113.145.camel@twins>
	 <6599ad830908060342m1fc8cdd2me25af248a8e0e183@mail.gmail.com>
	 <1249556540.32113.191.camel@twins>
	 <6599ad830908060424r72e1aa12g2b246785e7bc039c@mail.gmail.com>
	 <1249558761.32113.262.camel@twins>
	 <20090806151922.GB6747@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 17:24:46 +0200
Message-Id: <1249572286.32113.527.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 08:19 -0700, Paul E. McKenney wrote:
> 
> > So yes, putting a rwsem in there sounds fine, you're already bouncing
> > it.
> 
> If the critical section is small, is an rwsem really better than a
> straight mutex?

Well, my understanding was that it needed to surround much, if not all,
of clone(). That's a rather large bit of code.

