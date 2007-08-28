Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbXH1Une@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbXH1Une (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXH1UnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:43:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54738
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbXH1UnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:43:19 -0400
Date: Tue, 28 Aug 2007 13:43:17 -0700 (PDT)
Message-Id: <20070828.134317.118522881.davem@davemloft.net>
To: rdreier@cisco.com
Cc: tom@opengridcomputing.com, jeff@garzik.org, swise@opengridcomputing.com,
       mshefty@ichips.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <adair6zjvq8.fsf@cisco.com>
References: <adalkc5u1o9.fsf@cisco.com>
	<20070820.235804.85409183.davem@davemloft.net>
	<adair6zjvq8.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 28 Aug 2007 12:38:07 -0700

> It seems that the NIC would also have to look into a TCP stream (and
> handle out of order segments etc) to find message boundaries for this
> to be equivalent to what an RDMA NIC does.

It would work for data that accumulates in-order, give or take a small
window, just like LRO does.
