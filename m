Return-Path: <linux-kernel-owner+w=401wt.eu-S1423123AbXDXVuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423123AbXDXVuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXDXVuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:50:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55254
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754372AbXDXVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:50:19 -0400
Date: Tue, 24 Apr 2007 14:50:26 -0700 (PDT)
Message-Id: <20070424.145026.128110905.davem@davemloft.net>
To: ashok.raj@intel.com
Cc: ak@suse.de, linux-kernel@vger.kernel.org, akpm@osdl.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       shaohua.li@intel.com
Subject: Re: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when
 devices cannot address entire range.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070424213835.GB31920@linux-os.sc.intel.com>
References: <200704242312.54738.ak@suse.de>
	<20070424.142351.62664098.davem@davemloft.net>
	<20070424213835.GB31920@linux-os.sc.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>
Date: Tue, 24 Apr 2007 14:38:35 -0700

> Its not clear if we have a very generic device breakage.. most devices
> on these platforms are going to be more recent, (except maybe some
> legacy fd)... 

I'm not so sure, there are some "modern" sound cards that have
a 31-bit DMA addressing limitation because they use the 31st
bit as a status bit in their DMA descriptors :-)
