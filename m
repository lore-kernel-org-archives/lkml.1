Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYHKVNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYHKVNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYHKVMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:12:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49862
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbYHKVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:12:53 -0400
Date: Mon, 11 Aug 2008 14:12:54 -0700 (PDT)
Message-Id: <20080811.141254.165409473.davem@davemloft.net>
To: rick.jones2@hp.com
Cc: rdreier@cisco.com, jgarzik@pobox.com, swise@opengridcomputing.com,
       divy@chelsio.com, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com,
       leedom@chelsio.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A08145.6060703@hp.com>
References: <adazlnlzc60.fsf@cisco.com>
	<20080809.224637.69833549.davem@davemloft.net>
	<48A08145.6060703@hp.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rick Jones <rick.jones2@hp.com>
Date: Mon, 11 Aug 2008 11:13:25 -0700

> David Miller wrote:
> > And I even wonder, these days, if you probably get %90 or more of the
> > gain these "optimized" iSCSI connections obtain from things like LRO.
> > And since LRO can be done entirely in software (although stateless
> > HW assistence helps), it is even a NIC agnostic performance improvement.
> 
> Probably depends on whether or not the iSCSI offload solutions are doing 
> zero-copy receive into the filecache?

That's a data placement issue, which also can be solved with
stateless offloading.
