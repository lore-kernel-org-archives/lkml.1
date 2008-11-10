Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYKJUgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYKJUgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbYKJUg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:36:26 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:58470 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYKJUgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:36:25 -0500
X-IronPort-AV: E=Sophos;i="4.33,578,1220227200"; 
   d="scan'208";a="114632517"
From: Roland Dreier <rdreier@cisco.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Fix suppression of port activation events
References: <200806061835.43802.fenkes@de.ibm.com>
	<48499C11.7030504@gmail.com> <200811071742.51867.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 10 Nov 2008 12:36:23 -0800
In-Reply-To: <200811071742.51867.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Fri, 7 Nov 2008 17:42:51 +0100")
Message-ID: <adaod0nqpx4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Nov 2008 20:36:24.0116 (UTC) FILETIME=[FF5A0740:01C94373]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > A previous fix introduced a regression where port activation events were
 > dropped unconditionally if port autodetection was not enabled. Fixed.

Is this a fix to "IB/ehca: Remove reference to special QP in case of
port activation failure"?  Because if so I can roll it into that patch,
since Linus hasn't pulled it yet.

 - R.
