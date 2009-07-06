Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZGFM0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZGFM0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZGFM0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:26:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:43764 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZGFM0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:26:23 -0400
Subject: Re: IOMMU and graphics cards
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: David Miller <davem@davemloft.net>, airlied@linux.ie,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       Zhenyu Wang <zhenyu.z.wang@intel.com>
In-Reply-To: <20090508093526.GB13708@8bytes.org>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
	 <20090507100114.GF4059@amd.com>
	 <1241691721.3531.73.camel@macbook.infradead.org>
	 <20090507.113632.210373283.davem@davemloft.net>
	 <20090508093526.GB13708@8bytes.org>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 13:26:17 +0100
Message-Id: <1246883177.2615.33.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 11:35 +0200, Joerg Roedel wrote:
> The other way to achieve consistency is to remove the workaround from
> VT-d code which significantly increases the chance to get the broken
> stuff fixed. David?

It's gone from 2.6.31-rc2, but even the in-tree drivers break, so I
think we have to put it back for 2.6.31 (I've sent Linus the pull
request already). 

I do intend to remove it again for 2.6.32 though, and I filed 
http://bugzilla.kernel.org/show_bug.cgi?id=13721

For now it's got a clearer description ("Workaround broken graphics
drivers") and defaults to 'n'.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

