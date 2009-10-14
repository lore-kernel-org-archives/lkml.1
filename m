Return-Path: <linux-kernel-owner+w=401wt.eu-S934550AbZJNPfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbZJNPfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934520AbZJNPfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:35:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:37652 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbZJNPfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:35:19 -0400
Subject: RE: DMAR regression in 2.6.31 leads to ext4 corruption?
From: David Woodhouse <dwmw2@infradead.org>
To: Bhavesh Davda <bhavesh@vmware.com>
Cc: Andy Isaacson <adi@hexapodia.org>, Chris Wright <chrisw@sous-sol.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <8B1F619C9F5F454E81D90D3C161698D7017DD55F68@EXCH-MBX-3.vmware.com>
References: <20091009061729.GA31242@hexapodia.org>
	 <20091010000926.GA17547@sequoia.sous-sol.org>
	 <20091010014714.GG30557@hexapodia.org>
	 <1255522166.4523.238.camel@macbook.infradead.org>
	 <8B1F619C9F5F454E81D90D3C161698D7017DD55F68@EXCH-MBX-3.vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 16:34:23 +0100
Message-Id: <1255534463.5351.2.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 08:26 -0700, Bhavesh Davda wrote:
> [    0.224001] DRHD: handling fault status reg 3
> [    0.224003] DMAR:[DMA Write] Request device [00:02.0] fault addr 95e7000
> [    0.224004] DMAR:[fault reason 05] PTE Write access is not set 

It's harmless. Your BIOS just isn't completely initialising the GATT.

-- 
dwmw2

