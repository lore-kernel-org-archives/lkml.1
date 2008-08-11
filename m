Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYHKSN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYHKSN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYHKSNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:13:35 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48372 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbYHKSNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:13:33 -0400
Message-ID: <48A08145.6060703@hp.com>
Date: Mon, 11 Aug 2008 11:13:25 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rdreier@cisco.com, jgarzik@pobox.com, swise@opengridcomputing.com,
       divy@chelsio.com, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com,
       leedom@chelsio.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
References: <489C8BEB.8060001@opengridcomputing.com>	<489CC58D.4010606@pobox.com> <adazlnlzc60.fsf@cisco.com> <20080809.224637.69833549.davem@davemloft.net>
In-Reply-To: <20080809.224637.69833549.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> And I even wonder, these days, if you probably get %90 or more of the
> gain these "optimized" iSCSI connections obtain from things like LRO.
> And since LRO can be done entirely in software (although stateless
> HW assistence helps), it is even a NIC agnostic performance improvement.

Probably depends on whether or not the iSCSI offload solutions are doing 
zero-copy receive into the filecache?

rick jones
