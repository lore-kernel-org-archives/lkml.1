Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZEKRWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZEKRWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZEKRWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:22:32 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:33983 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbZEKRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:22:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.40,329,1238968800";   d="scan'208";a="5640880"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: "'Andi Kleen'" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       linux-numa@vger.kernel.org, brice.goglin@inria.fr,
       "'Terboven, Christian'" <terboven@rz.rwth-aachen.de>,
       anmey@rz.rwth-aachen.de, Boris Bierbaum <boris@lfbs.rwth-aachen.de>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
 <001501c9d248$69e2a870$3da7f950$@rwth-aachen.de>
 <20090511163719.GA19296@one.firstfloor.org>
In-reply-to: <20090511163719.GA19296@one.firstfloor.org>
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
Date: Mon, 11 May 2009 19:22:31 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <000301c9d25d$113c0f30$33b42d90$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnSVgWdILyzYlYeSFKyrgZVRck4hgAAf59Q
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Monday, May 11, 2009 6:37 PM
> To: Stefan Lankes
> Cc: 'Andi Kleen'; linux-kernel@vger.kernel.org;
> Lee.Schermerhorn@hp.com; linux-numa@vger.kernel.org;
> brice.goglin@inria.fr; 'Terboven, Christian'; anmey@rz.rwth-aachen.de;
> 'Boris Bierbaum'
> Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
> 
> > By default, mbind only has an effect on new allocations. I think that
> this
> 
> Nope, it affects existing pages too, it can even move pages
> if you ask for it.
> 

I know this possibility. I thought that "affinity-on-next-touch" fit better
to madvise. Brice told already the technical reasons for preferring of
madvise.

> > For instance, Norden's PDE solvers using adaptive mesh refinements
> (AMR) [1]
> > is an application with a dynamic access pattern. We use this example
> to
> > evaluate the performance of our patch. We ran this solver on our
> > quad-socket, dual-core Opteron 875 (2.2GHz) system running CentOS
> 5.2. The
> > code was already optimized for NUMA architectures. Before the arrays
> are
> > initialized, the threads are bound to one core. In our test case, the
> solver
> > needs 5318s. If we use our kernel extension, the solver needs 4489s.
> 
> Okay that sounds like good numbers.
> 
> > Currently, we are testing some other apps.
> 
> Please keep the list updated.
> 

I will do it.

Stefan

