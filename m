Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbXGUEVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbXGUEVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbXGUEUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:20:52 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28211 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXGUEUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:20:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABImoUarR7PE/2dsb2JhbAA
X-IronPort-AV: i="4.16,565,1175497200"; 
   d="scan'208"; a="186015047:sNHT25266168"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, fenkes@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: [ofa-general] [PATCH 5/5] ehca: Support small QP queues
X-Message-Flag: Warning: May contain useful information
References: <200707201604.17991.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 21:20:49 -0700
In-Reply-To: <200707201604.17991.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Fri, 20 Jul 2007 16:04:17 +0200")
Message-ID: <adawswu5qvy.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jul 2007 04:20:50.0238 (UTC) FILETIME=[84FC8DE0:01C7CB4E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.  I fixed this up myself to work with commit 20c2df83,
which got rid of the destructor argument to kmem_cache_create() -- you
probably want to check my tree to make sure it's OK.

Also the same as I said before about checkpatch.pl's warning:

WARNING: externs should be avoided in .c files
#337: FILE: drivers/infiniband/hw/ehca/ehca_pd.c:91:
+	extern struct kmem_cache *small_qp_cache;

please fix that up when you get a chance
