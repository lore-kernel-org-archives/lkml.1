Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYKUS2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYKUS2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYKUS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:28:07 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:60188 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbYKUS2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:28:06 -0500
X-IronPort-AV: E=Sophos;i="4.33,645,1220227200"; 
   d="scan'208";a="108285671"
From: Roland Dreier <rdreier@cisco.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Fix locking for shca_list_lock
References: <200806061835.43802.fenkes@de.ibm.com>
	<200811211637.15300.fenkes@de.ibm.com>
	<1227283347.3599.8.camel@johannes.berg>
	<200811211718.17489.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 21 Nov 2008 10:28:03 -0800
In-Reply-To: <200811211718.17489.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Fri, 21 Nov 2008 17:18:16 +0100")
Message-ID: <adawsexexxo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Nov 2008 18:28:04.0461 (UTC) FILETIME=[E48B29D0:01C94C06]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good... I'll add this for 2.6.29, since as far as I can tell this
bug has been there approximately forever already.
