Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbXHPQRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbXHPQRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbXHPQRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:17:32 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:38311 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbXHPQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:17:30 -0400
X-IronPort-AV: i="4.19,272,1183359600"; 
   d="scan'208"; a="392648496:sNHT46684326"
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, fenkes@de.ibm.com,
       "\"Hoang-Nam Nguyen\" @dyn-9-152-249-53" 
	<Hoang-Nam.Nguyen@d01av04.pok.ibm.com>
Subject: Re: [ofa-general] [PATCH 7/7] IB/ehca: Prevent overwriting QP init attributes given by caller
X-Message-Flag: Warning: May contain useful information
References: <200708082044.38247.ossrosch@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 16 Aug 2007 09:17:22 -0700
In-Reply-To: <200708082044.38247.ossrosch@linux.vnet.ibm.com> (Stefan Roscher's message of "Wed, 8 Aug 2007 20:44:37 +0200")
Message-ID: <adatzqz1mjx.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Aug 2007 16:17:23.0398 (UTC) FILETIME=[EDA5A660:01C7E020]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't understand this patch.  <rdma/ib_verbs.h> says this about
ib_create_qp():

 * @qp_init_attr: A list of initial attributes required to create the
 *   QP.  If QP creation succeeds, then the attributes are updated to
 *   the actual capabilities of the created QP.

So it seems the current code is actually correct and your patch breaks
it??
