Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbYJWXNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbYJWXNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756891AbYJWXKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:10:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:4354 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbYJWXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=i5RF+aKdDitcQtiVxebZSc8yWugZjeJNWCErbiVGlqReLQS6ctsMVaQKhN5F/qbglB
         I1HMi5BM6Lri5lgmcmXDdSvQh9iuBWqTV0hpNRInap2gxAnvUCGTShf0HB7Lwl5UgLbx
         S7/asYYq712rQlsjAP47KUZv6Tr//Hxvzkb/E=
Message-ID: <a4423d670810231609h76323d2fqa4ed7d9ba0a46e3b@mail.gmail.com>
Date: Fri, 24 Oct 2008 03:09:52 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, fenghua.yu@intel.com,
       tony.luck@intel.com, David.Woodhouse@intel.com
Subject: build failure at x86/kernel/pci-dma.c with !CONFIG_PCI
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/built-in.o: In function `iommu_setup':
pci-dma.c:(.init.text+0x36ad): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x36cc): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x3711): undefined reference to `forbid_dac

commit 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
Author: Fenghua Yu <fenghua.yu@intel.com>
Date:   Thu Oct 16 18:02:32 2008 -0700

    intel-iommu: IA64 support
