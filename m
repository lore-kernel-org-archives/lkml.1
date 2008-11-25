Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYKYXOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYKYXOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYKYXNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:13:54 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:47748 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYKYXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:13:53 -0500
X-IronPort-AV: E=Sophos;i="4.33,666,1220227200"; 
   d="scan'208";a="110146438"
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
Subject: Re: [PATCH] IB/ehca: Change misleading error message
References: <200806061835.43802.fenkes@de.ibm.com>
	<48499C11.7030504@gmail.com> <200811251358.06729.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 25 Nov 2008 15:13:51 -0800
In-Reply-To: <200811251358.06729.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Tue, 25 Nov 2008 13:58:06 +0100")
Message-ID: <aday6z7csb4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Nov 2008 23:13:52.0108 (UTC) FILETIME=[7AFD72C0:01C94F53]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The error message printed when the eHCA driver prevents memory hotplug is
 > misleading -- the user might think that hot-removing the lhca, hotplugging
 > memory, then hot-adding the lhca again will work, but it doesn't.

That's too bad... I applied this patch but out of curiousity, why
doesn't the hot-remove/hot-add work?  I would have thought that
re-registering all of memory after the hot-add would do the right thing.
