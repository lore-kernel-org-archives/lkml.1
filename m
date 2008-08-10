Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYHJFri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYHJFri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 01:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYHJFrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 01:47:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36396
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbYHJFrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 01:47:24 -0400
Date: Sat, 09 Aug 2008 22:47:25 -0700 (PDT)
Message-Id: <20080809.224725.130946315.davem@davemloft.net>
To: rdreier@cisco.com
Cc: jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <adavdy9zc2k.fsf@cisco.com>
References: <489CC58D.4010606@pobox.com>
	<20080809.002840.167363463.davem@davemloft.net>
	<adavdy9zc2k.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Sat, 09 Aug 2008 22:14:11 -0700

>  > Also, I find it ironic that the port abduction is being asked for in
>  > order to be "compatible with existing tools" yet in fact this stuff
>  > breaks everything.  You can't netfilter this traffic, you can't apply
>  > qdiscs to it, you can't execut TC actions on them, you can't do
>  > segmentation offload on them, you can't look for the usual TCP MIB
>  > statistics on the connection, etc. etc. etc.
> 
> We already support offloads that break other features, eg large receive
> offload breaks forwarding.  We deal with it.

We turn it off.  If I want to shape or filter one of these iSCSI
connections can we turn it off?

It's funny you mention LRO because it probably gives most of whatever
gain these special iSCSI TCP connection offload things get.
