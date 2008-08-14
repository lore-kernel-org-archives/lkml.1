Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYHNCJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYHNCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbYHNCJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:09:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44309
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757316AbYHNCJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:09:04 -0400
Date: Wed, 13 Aug 2008 19:09:05 -0700 (PDT)
Message-Id: <20080813.190905.31828583.davem@davemloft.net>
To: tom@opengridcomputing.com
Cc: rdreier@cisco.com, rick.jones2@hp.com, jgarzik@pobox.com,
       swise@opengridcomputing.com, divy@chelsio.com, kxie@chelsio.com,
       netdev@vger.kernel.org, open-iscsi@googlegroups.com,
       michaelc@cs.wisc.edu, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, dm@chelsio.com, leedom@chelsio.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
From: David Miller <davem@davemloft.net>
In-Reply-To: <48A389DB.9050002@opengridcomputing.com>
References: <adatzdoiklo.fsf@cisco.com>
	<20080813.161237.10205799.davem@davemloft.net>
	<48A389DB.9050002@opengridcomputing.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Tucker <tom@opengridcomputing.com>
Date: Wed, 13 Aug 2008 20:26:51 -0500

> Is there any chance your could discuss exactly how a stateless adapter 
> can determine if a network segment
> is in-order, next expected, minus productive ack, paws compliant, etc... 
> without TCP state?

If you're getting packets out of order, data placement optimizations
are the least of your concerns.

In fact this is exactly where we want all of the advanced loss
handling algorithms of the Linux TCP stack to get engaged.
