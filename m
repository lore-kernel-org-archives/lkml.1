Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZIZStu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZIZStu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZIZStt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:49:49 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:29487 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZIZSts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:49:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 0/2] cxgb3/cxgb3i: added support of private MAC address and provisioning packet handler for iSCSI
Date: Sat, 26 Sep 2009 11:55:36 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334066E713E@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 0/2] cxgb3/cxgb3i: added support of private MAC address and provisioning packet handler for iSCSI
Thread-Index: Aco+eZO3CUWSeZP8TmiavQXL/eW0NQAYRI4A
References: <200909252225.n8PMPaqI031748@localhost.localdomain><20090925.152430.119503066.davem@davemloft.net><8A71B368A89016469F72CD08050AD334066E7019@maui.asicdesigners.com> <20090926.001646.06991481.davem@davemloft.net>
From: "Karen Xie" <kxie@chelsio.com>
To: "David Miller" <davem@davemloft.net>
Cc: <michaelc@cs.wisc.edu>, <James.Bottomley@HansenPartnership.com>,
       "Steve Wise" <swise@opengridcomputing.com>,
       "Divy Le Ray" <divy@chelsio.com>, "Rakesh Ranjan" <rakesh@chelsio.com>,
       <linux-scsi@vger.kernel.org>, <open-iscsi@googlegroups.com>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, understood.

We are submitting a new version that would be isolated to changes to the
net driver only and would not affect scsi driver.

Thanks a lot.
Karen

-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Saturday, September 26, 2009 12:17 AM
To: Karen Xie
Cc: michaelc@cs.wisc.edu; James.Bottomley@HansenPartnership.com; Steve
Wise; Divy Le Ray; Rakesh Ranjan; linux-scsi@vger.kernel.org;
open-iscsi@googlegroups.com; linux-kernel@vger.kernel.org;
netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] cxgb3/cxgb3i: added support of private MAC
address and provisioning packet handler for iSCSI

From: "Karen Xie" <kxie@chelsio.com>
Date: Fri, 25 Sep 2009 15:34:22 -0700

> Hmm, I am wondering how could this merge activity to be coordinated?
If
> only the driver/scsi change is merged, then it won't compile either,
> since it requires the driver/net change.

That's rediculious, frankly.

Since they are two seperate changes you are knowingly creating
a bisection point that will not work.  That's wrong.

You need to split up the changes so that each and every one of them
are independant and the tree can be checked out at either of them and
everything can be expected to work.
