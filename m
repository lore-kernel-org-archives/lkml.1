Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbZFLNv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbZFLNv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934232AbZFLNsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:48:42 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:47238 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933254AbZFLNsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:48:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.42,209,1243807200";   d="scan'208";a="8036921"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: "'Brice Goglin'" <Brice.Goglin@inria.fr>
Cc: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Lee.Schermerhorn@hp.com, linux-numa@vger.kernel.org,
       Boris Bierbaum <boris@lfbs.rwth-aachen.de>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
 <20090612103251.GJ25568@one.firstfloor.org>
 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de> <4A324A4E.1060405@inria.fr>
In-reply-to: 
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
Date: Fri, 12 Jun 2009 15:48:36 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <004601c9eb64$7c23fcc0$746bf640$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnrWXHDyy/c1RqIQvS1JLHUD9yOpQAAVQdAAAItwQA=
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> 
> MPOL_MF_LAZY is used as flag and does not specify a new policy.
> Therefore, MPOL_MF_LAZY isn't stored in a VMA. The flag is only used to
> detect that the system call mbind has to unmap these pages.
> 

In one of my previous e-mails, I wrote that Lee use the normal NUMA memory
policies. This statement was unclear. Lee's patches define no new memory
policy. He adds only a new flag. The using of mbind looks for me smarter as
the using of madvise. 

Stefan

