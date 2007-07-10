Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbXGJNtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbXGJNtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXGJNtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:49:09 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:31543 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbXGJNtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:49:08 -0400
In-Reply-To: <adazm25w998.fsf@cisco.com>
Subject: Re: [PATCH 06/13] IB/ehca: Set SEND_GRH flag for all non-LL UD QPs on eHCA2
To: Roland Dreier <rdreier@cisco.com>
Cc: "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF5A4240D2.61426860-ONC1257314.0047B786-C1257314.004BE620@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Tue, 10 Jul 2007 18:35:49 +0200
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 10/07/2007 15:49:05
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> What decides if a QP is LL or not?
>
>  - R.
Currently we use a high bit in the QP type, which is not how we want to
keep it permanently.
What would you suggest, add two additional LL QP types, or change something
more fundamental
in libibverbs and kernel ib core?
We think we can get along quite well with the existing parameters in the
current create QP.
The current user-kernel interface is ok for these new QPs for post_send +
post_recv,
but unfortunately the libibverbs userspace calls don't match exactly how
the LL queues are to be used.
We would need something like the LL QP interface in libehca in libibverbs
to keep that interface generic.

We didn't see a usage yet for LL QP in kernel, so maybe we should continue
that
discussion on general@openfabrics only.
We could provide example code in libehca/samples if needed.


Gruss / Regards
Christoph + Nam

