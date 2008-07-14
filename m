Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYGNM3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYGNM3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYGNM27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:28:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55796
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbYGNM26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:28:58 -0400
Date: Mon, 14 Jul 2008 05:28:59 -0700 (PDT)
Message-Id: <20080714.052859.88212003.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0807140805380.10106@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807131947090.7803@devserv.devel.redhat.com>
	<20080713.174855.234796356.davem@davemloft.net>
	<Pine.LNX.4.64.0807140805380.10106@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Mon, 14 Jul 2008 08:16:13 -0400 (EDT)

> As you mentioned ESP driver, it declares .sg_tablesize = SG_ALL, so 
> BIO_VMERGE_BOUNDARY has no effect on the operation of this driver. Any 
> other driver where BIO_VMERGE_BOUNDARY does matter?

When BIO_VMERGE_BOUNDARY is turned on, requests that would not
otherwise fit into the device's limits, can.

It's the only way to know ahead of time that the IOMMU is going
to merge things for us.
