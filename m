Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXFPVwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXFPVwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 17:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXFPVwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 17:52:22 -0400
Received: from nat0.xsigo.com ([216.184.48.10]:30108 "HELO main.xsigo.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750723AbXFPVwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 17:52:22 -0400
Subject: need help with kmap_atomic() behavior
From: Hari Hara Kumar M <hari@xsigo.com>
Reply-To: hari@xsigo.com
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <463796B1.9060706@student.ltu.se>
References: <20070501180113.20160.77978.sendpatchset@thinktank.campus.ltu.se>
	 <Pine.LNX.4.64.0705011415070.13459@localhost.localdomain>
	 <1178044924.4320.29.camel@mulgrave.il.steeleye.com>
	 <463796B1.9060706@student.ltu.se>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Jun 2007 14:52:21 -0700
Message-Id: <1182030741.26268.59.camel@hmaharaj-ws.xsigo.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

We are mapping struct page ptrs from scattergather list entries using
kmap_atomic(page_ptr, KM_USER0) to get the virtual address for doing a
copy to work around some alignment restrictions in our driver.

If the first entry in the scatterlist has length > 4k (say 11k) and has
an offset of 1k then, will kmap of the struct page ptr in this
scattergather entry map all of the relevant pages (3 in this case for
11k) needed to cover this sg entry?

Thanks in advance.
-Hari


