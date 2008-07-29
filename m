Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbYG2F01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbYG2F01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYG2F0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:26:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56561
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751902AbYG2F0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:26:18 -0400
Date: Mon, 28 Jul 2008 22:26:18 -0700 (PDT)
Message-Id: <20080728.222618.74785329.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: sfr@canb.auug.org.au, mingo@elte.hu, joerg.roedel@amd.com,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729133909L.fujita.tomonori@lab.ntt.co.jp>
References: <20080729104722H.fujita.tomonori@lab.ntt.co.jp>
	<20080729135652.f89042c1.sfr@canb.auug.org.au>
	<20080729133909L.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 29 Jul 2008 13:38:53 +0900

> Agreed... As I said before, this is not urgent at all so we didn't
> need to rush.

Please, if you are going to add such interface, add
"const unsigned long io_page_size" argument so that
powerpc and sparc can use it too.
