Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXL0X5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXL0X5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 18:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXL0X4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 18:56:55 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29675 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbXL0X4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 18:56:54 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Thu, 27 Dec 2007 23:55:43 +0000
Subject: RE: [PATCH 1/3] cciss: export more attributes to sysfs (repost)
Thread-Topic: [PATCH 1/3] cciss: export more attributes to sysfs (repost)
Thread-Index: AchEJ5U1Y5hrLSX8TOSMxvauODdGIQEu6Iwg
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE15A296AD@G6W0268.americas.hpqcorp.net>
References: <20071214221744.GA32019@roadking.usa.hp.com>
 <20071221151647.ac8f864c.akpm@linux-foundation.org>
In-Reply-To: <20071221151647.ac8f864c.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Mike, what's going on?  I definitely told you last time I
> looked at this patch that it is a bug to call
> sysfs_remove_group() under spinlock, because
> sysfs_remove_group() takes sleeping locks.  Yet here it is again.
>
> Maybe you lost my email.  It is here:
> http://lkml.org/lkml/2007/11/20/77
>
>
> Also please see http://lkml.org/lkml/2007/11/20/79
>

Andrew,
My apologies. Obviously I did not read your email closely. When I return from vacation I will address these issues.

-- mikem
