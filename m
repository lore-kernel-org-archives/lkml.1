Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYHKVIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYHKVIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYHKVIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:08:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40594
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbYHKVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:08:37 -0400
Date: Mon, 11 Aug 2008 14:08:38 -0700 (PDT)
Message-Id: <20080811.140838.202229941.davem@davemloft.net>
To: rdreier@cisco.com
Cc: jgarzik@pobox.com, swise@opengridcomputing.com, divy@chelsio.com,
       kxie@chelsio.com, netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <adafxpbzga0.fsf@cisco.com>
References: <adazlnlzc60.fsf@cisco.com>
	<20080809.224637.69833549.davem@davemloft.net>
	<adafxpbzga0.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 11 Aug 2008 09:07:51 -0700

> Yes, that's the question -- are stateless offloads (plus CRC32C in the
> CPU etc) going to give good enough performance that the whole TCP
> offload exercise is pointless?

This is by definition true, over time.  And this has stedfastly proven
itself, over and over again.

That's why we call stateful offloads a point in time solution.
They are constantly being obsoleted by time.
