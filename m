Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbYHWIW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbYHWIW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 04:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbYHWIWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 04:22:39 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:8256 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbYHWIWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 04:22:37 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-MimeOLE:Content-class:MIME-Version:Content-Type:
   Content-Transfer-Encoding:Subject:Date:Message-ID:
   In-Reply-To:X-MS-Has-Attach:X-MS-TNEF-Correlator:
   Thread-Topic:thread-index:References:From:To:Cc:
   Return-Path:X-OriginalArrivalTime;
  b=rwB+483+L39WsmZzZtnNqF5P3Usv29e/8v0u78uwN2p7HjqRLJI/wsdn
   bUAklLT6WBPmWqbioYf9w7IdNQogT0GGBJ0ezyFY5SdhUYFnU5I9gdXx+
   4aPoDxCDSH+8fFC;
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/4 2.6.28] cxgb3i - cxgb3i iscsi driver
Date: Sat, 23 Aug 2008 13:52:26 +0530
Message-ID: <46A00B48CC54E4468EF6911F877AC4CA018D73BB@blrx3m10.blr.amer.dell.com>
In-Reply-To: <20080822124844.b05ee3e8.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/4 2.6.28] cxgb3i - cxgb3i iscsi driver
thread-index: AckEkO235qa5D60oRUy1eIq+yrYfjQAZ0nAA
References: <200808221840.m7MIeuvB004442@localhost.localdomain> <20080822124844.b05ee3e8.akpm@linux-foundation.org>
From: <Shyam_Iyer@Dell.com>
To: <akpm@linux-foundation.org>, <kxie@chelsio.com>
Cc: <netdev@vger.kernel.org>, <open-iscsi@googlegroups.com>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jgarzik@pobox.com>, <davem@davemloft.net>, <michaelc@cs.wisc.edu>,
       <swise@opengridcomputing.com>, <rdreier@cisco.com>, <daisyc@us.ibm.com>,
       <wenxiong@us.ibm.com>, <bhua@us.ibm.com>, <divy@chelsio.com>,
       <dm@chelsio.com>, <leedom@chelsio.com>, <kxie@chelsio.com>
X-OriginalArrivalTime: 23 Aug 2008 08:22:32.0301 (UTC) FILETIME=[63B601D0:01C904F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Andrew Morton wrote:
> > + *
> > + * Written by: Karen Xie (kxie@chelsio.com)  */
> > +
> > +#include "cxgb3i.h"
> > +
> > +#define DRV_MODULE_NAME         "cxgb3i"
> > +#define DRV_MODULE_VERSION      "1.0.0"

>I'd suggest that the version number just be removed.  It becomes
meaningless (and often misleading) once a driver is in the mainline
kernel.  People will >update the driver without changing the version
number.  Code external to the driver but which affects it can change.

>The kernel version identifier is really the only way in whcih you and
your support people can reproduce a user's code.

> > +#define DRV_MODULE_RELDATE      "May 1, 2008"

>Ditto.


It gives us a stick to ask vendors to maintain upstream versions of
driver code in the distros. 

While we are at this. I believe that there is not much of a standard for
driver versioning. If we automatically get a driver version from the
kernel version then it solves both problems. Thoughts ??

Thanks,
Shyam
