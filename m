Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbXGOJk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbXGOJk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbXGOJkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:40:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40021
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756722AbXGOJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:40:12 -0400
Date: Sun, 15 Jul 2007 02:40:15 -0700 (PDT)
Message-Id: <20070715.024015.126137834.davem@davemloft.net>
To: hch@infradead.org
Cc: ossthema@de.ibm.com, netdev@vger.kernel.org, raisch@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       stefan.roscher@de.ibm.com
Subject: Re: [RFC 0/3] lro: Generic Large Receive Offload for TCP traffic
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070715091253.GA15790@infradead.org>
References: <200707111621.24852.ossthema@de.ibm.com>
	<20070714.235748.02297780.davem@davemloft.net>
	<20070715091253.GA15790@infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 15 Jul 2007 10:12:53 +0100

> I'm not sure that's a good idea.  If current chips can't handle ipv6
> lro there is no way to actually test it and the code will surely bitrot.

Christoph, you can do LRO pretty much completely in software.

