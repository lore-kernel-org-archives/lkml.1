Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYHKVld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYHKVld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYHKVlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:41:20 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26120 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYHKVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:41:18 -0400
X-IronPort-AV: E=Sophos;i="4.32,191,1217808000"; 
   d="scan'208";a="138706250"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: rick.jones2@hp.com, jgarzik@pobox.com, swise@opengridcomputing.com,
       divy@chelsio.com, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com,
       leedom@chelsio.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <adazlnlzc60.fsf@cisco.com>
	<20080809.224637.69833549.davem@davemloft.net>
	<48A08145.6060703@hp.com>
	<20080811.141254.165409473.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 11 Aug 2008 14:41:16 -0700
In-Reply-To: <20080811.141254.165409473.davem@davemloft.net> (David Miller's
	message of "Mon, 11 Aug 2008 14:12:54 -0700 (PDT)")
Message-ID: <adad4kfxm9v.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Aug 2008 21:41:17.0021 (UTC) FILETIME=[FC1CF0D0:01C8FBFA]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Probably depends on whether or not the iSCSI offload solutions are doing 
 > > zero-copy receive into the filecache?
 > 
 > That's a data placement issue, which also can be solved with
 > stateless offloading.

How can you place iSCSI data properly with only stateless offloads?

 - R.
