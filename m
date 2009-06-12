Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbZFLLqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbZFLLqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZFLLql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:46:41 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:36601 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbZFLLqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:46:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.42,209,1243807200";   d="scan'208";a="15181118"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: "'Andi Kleen'" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
 <20090612103251.GJ25568@one.firstfloor.org>
In-reply-to: <20090612103251.GJ25568@one.firstfloor.org>
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
Date: Fri, 12 Jun 2009 13:46:37 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnrSAWLxyy3JP0zQfqNrSCjlluC6wABsM7g
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I analyze Lee Schermerhorn's migrate memory on cpu migration patches
> > (http://free.linux.hp.com/~lts/Patches/PageMigration/). I think that
> Lee
> > Schermerhorn add similar functionalities to the kernel. He called the
> > "affinity-on-next-touch" functionality "migrate_on_fault" and uses in
> his
> > patches the normal NUMA memory policies. Therefore, his solution fits
> better
> > to the Linux kernel. I tested his patches with our test applications
> and got
> > nearly the same performance results.
> 
> That's great to know.
> 
> I didn't think he had a per process setting though, did he?

He enables the support of migration-on-fault via cpusets (echo 1 >
/dev/cpuset/migrate_on_fault).
Afterwards, every process could initiate migration-on-fault via mbind(...,
MPOL_MF_MOVE|MPOL_MF_LAZY).

> > I found only patches for the kernel 2.6.25-rc2-mm1. Does someone
> develop
> > these patches further?
> 
> Not to much knowledge. Maybe Lee will pick them up again now that there
> are more use cases.
> 
> If he doesn't have time maybe you could update them?
 
We are planning to work in this area. I think that I could update these
patches. 
At least, I am able to support Lee.

Stefan

