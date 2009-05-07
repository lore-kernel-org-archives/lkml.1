Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbZEGKWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbZEGKWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZEGKWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:22:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:40624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbZEGKWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:22:10 -0400
Subject: Re: IOMMU and graphics cards
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, airlied@linux.ie
In-Reply-To: <20090507100114.GF4059@amd.com>
References: <20090428150531.GZ17438@amd.com>
	 <1240932530.2567.91.camel@macbook.infradead.org>
	 <20090428160448.GA17438@amd.com>
	 <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
	 <20090507100114.GF4059@amd.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 11:22:01 +0100
Message-Id: <1241691721.3531.73.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 12:01 +0200, Joerg Roedel wrote:
> > Looks like the DRM code uses the DMA API.
> 
> The proprietary drivers make problems so far. For the ATI one I am in
> contact with the developers to try to fix it. But I can't do anything
> about the other proprietary driver I am aware of :-(

I see no harm in "breaking" code which was already broken. If that's the
only reason we're enabling the graphics workaround, let's turn it off.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

