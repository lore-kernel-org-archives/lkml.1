Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYHKViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYHKViW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYHKViH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:38:07 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21545 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbYHKViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:38:05 -0400
X-IronPort-AV: E=Sophos;i="4.32,191,1217808000"; 
   d="scan'208";a="138704905"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <adavdy9zc2k.fsf@cisco.com>
	<20080809.224725.130946315.davem@davemloft.net>
	<adabpzzzg81.fsf@cisco.com>
	<20080811.140918.213422266.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 11 Aug 2008 14:37:59 -0700
In-Reply-To: <20080811.140918.213422266.davem@davemloft.net> (David Miller's
	message of "Mon, 11 Aug 2008 14:09:18 -0700 (PDT)")
Message-ID: <adaljz3xmfc.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Aug 2008 21:38:00.0100 (UTC) FILETIME=[86BD2E40:01C8FBFA]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > But as Herbert says, we can make LRO such that turning it off
 > isn't necessary.
 > 
 > Can we shape the iSCSI offload traffic without turning it off?

Sure... the same way we can ask the HW vendors to keep old headers
around when aggregating for LRO, we can ask HW vendors for hooks for
shaping iSCSI traffic.  And the Chelsio TCP speed record seems to show
that they already have pretty sophisticated queueing/shaping in their
current HW.

 - R.
