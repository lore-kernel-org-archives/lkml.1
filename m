Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZGFOTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZGFOTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZGFOTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:19:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:36556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbZGFOS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:18:59 -0400
Subject: Re: IOMMU and graphics cards
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>, Zhenyu Wang <zhenyu.z.wang@intel.com>,
       airlied@linux.ie, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       mingo@redhat.com, David Miller <davem@davemloft.net>
In-Reply-To: <20090706131156.GL5380@amd.com>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
	 <20090507100114.GF4059@amd.com>
	 <1241691721.3531.73.camel@macbook.infradead.org>
	 <20090507.113632.210373283.davem@davemloft.net>
	 <20090508093526.GB13708@8bytes.org>
	 <1246883177.2615.33.camel@macbook.infradead.org>
	 <20090706131156.GL5380@amd.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 15:18:52 +0100
Message-Id: <1246889932.2615.81.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 15:11 +0200, Joerg Roedel wrote:
> Ok, cool, that sounds good. Which in-kernel DRM drivers break with IOMMU
> for you? I'll may probably add a similar temporary workaround for AMD
> IOMMU too...

The Intel one definitely broke -- I don't know about the others. There
are some old patches at http://people.freedesktop.org/~zhen/agp-mm-*
which make it look like _all_ AGP drivers are broken.

I wouldn't bother adding the workaround -- as I said, I'm planning to
rip it out of 2.6.32 (and in linux-next as soon as it's reasonable to do
so). Let's just let them fix it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

