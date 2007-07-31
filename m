Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXGaQ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXGaQ3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761911AbXGaQ3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:29:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:43487 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705AbXGaQ3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:29:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,204,1183359600"; 
   d="scan'208";a="272722976"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: regression on HP zx1 platform from ACPI autoload modulespatches
Date: Tue, 31 Jul 2007 09:29:31 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A020E3AD2@scsmsx411.amr.corp.intel.com>
In-Reply-To: <1185882604.14987.2.camel@athlon>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: regression on HP zx1 platform from ACPI autoload modulespatches
Thread-Index: AcfTa1rXkCz2kBl5Suua6kqzCHv9xgAIqXXg
From: "Luck, Tony" <tony.luck@intel.com>
To: "Doug Chapman" <doug.chapman@hp.com>, "Tony Luck" <tony.luck@gmail.com>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>, <trenn@suse.de>
X-OriginalArrivalTime: 31 Jul 2007 16:29:32.0691 (UTC) FILETIME=[F9BAEE30:01C7D38F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> commit 8c8eb78f673c07b60f31751e1e47ac367c60c6b7

Oops.  I cut & pasted the wrong commit id.  The fix went in as
commit 7091138fb762aed22317b4ff91eb211e7da3865c.

> FYI, I did a git pull yesterday just before I hit this issue so I should
> have had the latest stuff.

So this confuses me.  Linus pulled this into his tree on Friday (IIRC), but
at the very latest on Saturday (as there is a commit *after* this one that
is dated 2007-07-28 19:29:37).

The patch that is in the tree appears to be identical to the one that
Thomas Renninger posted to this thread, and you confirmed as working.

So when you have a moment, please pull latest Linus tree.  Confirm that
this patch is present:
 $ grep hp_ioc_iommu_device_ids arch/ia64/hp/common/sba_iommu.c
 static const struct acpi_device_id hp_ioc_iommu_device_ids[] = {
 	.ids		= hp_ioc_iommu_device_ids,
 $

and that it builds and boots for you.

Thanks

-Tony
 
