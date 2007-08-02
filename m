Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbXHBVEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbXHBVEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXHBVEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:04:04 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6664 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbXHBVEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:04:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CACfjsUarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.19,215,1183359600"; 
   d="scan'208"; a="193357723:sNHT28383903"
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       paulus@samba.org, general@lists.openfabrics.org,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Subject: Re: [PATCH] ehca: map 4k firmware context of cq, qp to user space
X-Message-Flag: Warning: May contain useful information
References: <200708021139.31695.hnguyen@linux.vnet.ibm.com>
	<200708021608.16436.arnd@arndb.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 02 Aug 2007 14:03:59 -0700
In-Reply-To: <200708021608.16436.arnd@arndb.de> (Arnd Bergmann's message of "Thu, 2 Aug 2007 16:08:15 +0200")
Message-ID: <adawswd3ayo.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Aug 2007 21:03:59.0445 (UTC) FILETIME=[A581B050:01C7D548]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > remap_4k_pfn is defined in terms of remap_pfn_range if the base page
 > size if 4k, so you don't need this #ifdef afaics.

Good point.  I'll wait for an updated patch.
