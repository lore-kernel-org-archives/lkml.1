Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYHKVvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYHKVvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYHKVva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:51:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57227
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbYHKVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:51:29 -0400
Date: Mon, 11 Aug 2008 14:51:29 -0700 (PDT)
Message-Id: <20080811.145129.215922169.davem@davemloft.net>
To: rdreier@cisco.com
Cc: jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaljz3xmfc.fsf@cisco.com>
References: <adabpzzzg81.fsf@cisco.com>
	<20080811.140918.213422266.davem@davemloft.net>
	<adaljz3xmfc.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 11 Aug 2008 14:37:59 -0700

>  > But as Herbert says, we can make LRO such that turning it off
>  > isn't necessary.
>  > 
>  > Can we shape the iSCSI offload traffic without turning it off?
> 
> Sure... the same way we can ask the HW vendors to keep old headers
> around when aggregating for LRO, we can ask HW vendors for hooks for
> shaping iSCSI traffic.  And the Chelsio TCP speed record seems to show
> that they already have pretty sophisticated queueing/shaping in their
> current HW.

You don't get it, you can't add the entire netfilter and qdisc
stack into the silly firmware.

And we can't fix bugs there either.
