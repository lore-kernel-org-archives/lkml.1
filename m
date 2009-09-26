Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZIZHQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZIZHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 03:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZIZHQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 03:16:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42620
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbZIZHQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 03:16:27 -0400
Date: Sat, 26 Sep 2009 00:16:46 -0700 (PDT)
Message-Id: <20090926.001646.06991481.davem@davemloft.net>
To: kxie@chelsio.com
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com,
       swise@opengridcomputing.com, divy@chelsio.com, rakesh@chelsio.com,
       linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] cxgb3/cxgb3i: added support of private MAC
 address and provisioning packet handler for iSCSI
From: David Miller <davem@davemloft.net>
In-Reply-To: <8A71B368A89016469F72CD08050AD334066E7019@maui.asicdesigners.com>
References: <200909252225.n8PMPaqI031748@localhost.localdomain>
	<20090925.152430.119503066.davem@davemloft.net>
	<8A71B368A89016469F72CD08050AD334066E7019@maui.asicdesigners.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Karen Xie" <kxie@chelsio.com>
Date: Fri, 25 Sep 2009 15:34:22 -0700

> Hmm, I am wondering how could this merge activity to be coordinated? If
> only the driver/scsi change is merged, then it won't compile either,
> since it requires the driver/net change.

That's rediculious, frankly.

Since they are two seperate changes you are knowingly creating
a bisection point that will not work.  That's wrong.

You need to split up the changes so that each and every one of them
are independant and the tree can be checked out at either of them and
everything can be expected to work.
