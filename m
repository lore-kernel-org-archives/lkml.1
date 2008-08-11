Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYHKVJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYHKVJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYHKVJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:09:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40608
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbYHKVJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:09:18 -0400
Date: Mon, 11 Aug 2008 14:09:18 -0700 (PDT)
Message-Id: <20080811.140918.213422266.davem@davemloft.net>
To: rdreier@cisco.com
Cc: jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <adabpzzzg81.fsf@cisco.com>
References: <adavdy9zc2k.fsf@cisco.com>
	<20080809.224725.130946315.davem@davemloft.net>
	<adabpzzzg81.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 11 Aug 2008 09:09:02 -0700

>  > We turn it off.  If I want to shape or filter one of these iSCSI
>  > connections can we turn it off?
> 
> That seems like a reasonable idea to me -- the standard thing to do when
> a NIC offload conflicts with something else is to turn off the offload
> and fall back to software.

But as Herbert says, we can make LRO such that turning it off
isn't necessary.

Can we shape the iSCSI offload traffic without turning it off?
