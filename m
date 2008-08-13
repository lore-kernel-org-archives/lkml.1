Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbYHMXDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbYHMXDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYHMXDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:03:19 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:41109 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbYHMXDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:03:17 -0400
X-IronPort-AV: E=Sophos;i="4.32,204,1217808000"; 
   d="scan'208";a="139725066"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: rick.jones2@hp.com, jgarzik@pobox.com, swise@opengridcomputing.com,
       divy@chelsio.com, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com,
       leedom@chelsio.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <adad4kfxm9v.fsf@cisco.com>
	<20080811.145313.178992274.davem@davemloft.net>
	<ada3al8k3l5.fsf@cisco.com>
	<20080813.150831.193391799.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 13 Aug 2008 16:03:15 -0700
In-Reply-To: <20080813.150831.193391799.davem@davemloft.net> (David Miller's
	message of "Wed, 13 Aug 2008 15:08:31 -0700 (PDT)")
Message-ID: <adatzdoiklo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Aug 2008 23:03:16.0159 (UTC) FILETIME=[C4F954F0:01C8FD98]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Like I said, you retain a "flow cache" (say it a million times, "flow
 > cache") that remembers the current parameters and the buffers
 > currently assigned to that flow and what offset within those buffers.

OK, I admit you could make something work -- add hooks for the low-level
driver to ask the iSCSI initiator where PDU boundaries are so it can
resync when something is evicted from the flow cache, have the initiator
format its tags in a special way to encode placement data, etc, etc.
The scheme does bring to mind Alan's earlier comment about pigs and
propulsion, though.

In any case, as I said in the part of my email that you snipped, the
real issue is not designing hypothetical hardware, but deciding how to
support the Chelsio, Broadcom, etc hardware that exists today.

 - R.
