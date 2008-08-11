Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYHKQJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYHKQJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYHKQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:09:41 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47626 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYHKQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:09:40 -0400
X-IronPort-AV: E=Sophos;i="4.31,342,1215388800"; 
   d="scan'208";a="138558759"
From: Roland Dreier <rdreier@cisco.com>
To: David Miller <davem@davemloft.net>
Cc: jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <489CC58D.4010606@pobox.com>
	<20080809.002840.167363463.davem@davemloft.net>
	<adavdy9zc2k.fsf@cisco.com>
	<20080809.224725.130946315.davem@davemloft.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 11 Aug 2008 09:09:02 -0700
In-Reply-To: <20080809.224725.130946315.davem@davemloft.net> (David Miller's
	message of "Sat, 09 Aug 2008 22:47:25 -0700 (PDT)")
Message-ID: <adabpzzzg81.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Aug 2008 16:09:02.0717 (UTC) FILETIME=[92578AD0:01C8FBCC]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > We turn it off.  If I want to shape or filter one of these iSCSI
 > connections can we turn it off?

That seems like a reasonable idea to me -- the standard thing to do when
a NIC offload conflicts with something else is to turn off the offload
and fall back to software.

 - R.
