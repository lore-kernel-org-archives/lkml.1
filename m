Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab0CIEzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 23:55:14 -0500
Received: from sh.osrg.net ([192.16.179.4]:32813 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575Ab0CIEyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 23:54:37 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       rdunlap@xenotime.net, davem@davemloft.net
Subject: [PATCH -mm 0/3] Documentation: convert PCI-DMA-mapping.txt to use the generic DMA API
Date: Tue,  9 Mar 2010 13:53:06 +0900
Message-Id: <1268110389-12444-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Mar 2010 13:54:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI DMA API is just the wrapper of the DMA API after the patchset
in -mm:

http://marc.info/?l=linux-kernel&m=126596737604808&w=2

Driver writers are always able to use the DMA API with any bus. Now we
can remove the PCI DMA API in Documentation and tell driver writers to
use the DMA API at ll times.

This renames PCI-DMA-mapping.txt to DMA-API-HOWTO.txt and rearrange
two DMA-API docs in the following way:

- DMA-API.txt gives a concise description of the DMA API.
- DMA-API-HOWTO.txt is a guide that provides actual code examples of how
to use the DMA API.

=
 .../{PCI/PCI-DMA-mapping.txt => DMA-API-HOWTO.txt} |  352 ++++++++++----------
 Documentation/DMA-API.txt                          |  154 +--------
 2 files changed, 188 insertions(+), 318 deletions(-)


