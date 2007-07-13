Return-Path: <linux-kernel-owner+w=401wt.eu-S935285AbXGMI1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285AbXGMI1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761831AbXGMI0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:26:51 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:44104 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760895AbXGMI0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:26:50 -0400
In-Reply-To: <adawsx55ys3.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/10] IB/ehca: Multiple Event Queues, MR/MW rework, large page
 MRs, fixes
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFEE70CCDD.88537E20-ONC1257317.002E2CF5-C1257317.002E786F@de.ibm.com>
Date: Fri, 13 Jul 2007 10:26:39 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 13/07/2007 10:26:40,
	Serialize complete at 13/07/2007 10:26:40
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > [09/10] fixes a lot of checkpatch.pl warnings
> 
> Are these warnings from earlier patches in the series, or problems
> that already existed in the code?  If they are coming from other
> patches in the series, please just fix the earlier patches before I
> merge them.

Nam did a diff -Nurp empty_dir ehca | checkpatch.pl and fixed all the
existing problems in the code. That's why this is such a big hunk -
we've been doing the pointer-typecast thing wrong for a long time,
for example.

Joachim
