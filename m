Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbXIZTX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbXIZTX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbXIZTXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:23:21 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:31034 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbXIZTXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:23:20 -0400
X-IronPort-AV: E=Sophos;i="4.21,198,1188802800"; 
   d="scan'208";a="528445005"
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Change dmapool free block management
X-Message-Flag: Warning: May contain useful information
References: <20070926185757.GM3899@parisc-linux.org>
	<1190833279354-git-send-email-willy@linux.intel.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 26 Sep 2007 12:23:15 -0700
In-Reply-To: <1190833279354-git-send-email-willy@linux.intel.com> (Matthew Wilcox's message of "Wed, 26 Sep 2007 15:01:18 -0400")
Message-ID: <adafy11ten0.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Sep 2007 19:23:16.0335 (UTC) FILETIME=[B04087F0:01C80072]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Also add documentation for how dma pools work, move the header above the
 > includes, add my copyright, add the original author's copyright, add a
 > GPL v2 licence to the file and fix the includes.

The fact that you have all these other changes mixed in makes the main
change very difficult to review.  Also I assume the main change is
"Change dmapool free block management" -- but I'm left wondering
exactly how and why you're changing it.

 - R.
