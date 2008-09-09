Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYIIQRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYIIQRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYIIQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:17:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:1348 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbYIIQRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:17:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,366,1217833200"; 
   d="scan'208";a="614435610"
From: "Luck, Tony" <tony.luck@intel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "mingo@redhat.com" <mingo@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 9 Sep 2008 09:17:05 -0700
Subject: RE: [PATCH 1/4] add is_buffer_dma_capable helper function
Thread-Topic: [PATCH 1/4] add is_buffer_dma_capable helper function
Thread-Index: AckSlldNXdVExyy3QPKvdNmj1KDPyQAAOpvQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA30A14789F@orsmsx505.amr.corp.intel.com>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr, size_t size)
+{
+       return addr + size <= mask;
+}

Do we care about wrap-around (e.g. addr=0xffffffffffffffff size=2)?

-Tony
