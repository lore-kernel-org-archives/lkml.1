Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbXIUUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbXIUUbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXIUUbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:31:11 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:12720 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXIUUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:31:09 -0400
X-IronPort-AV: E=Sophos;i="4.20,285,1186383600"; 
   d="scan'208";a="401002415"
To: Andi Kleen <andi@firstfloor.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       David Miller <davem@davemloft.net>, jeff@garzik.org, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
X-Message-Flag: Warning: May contain useful information
References: <200709211201.24475.vda.linux@googlemail.com>
	<200709211803.55554.vda.linux@googlemail.com>
	<20070921.104912.41646795.davem@davemloft.net>
	<200709211905.23946.vda.linux@googlemail.com>
	<p73ps0b93ph.fsf@bingen.suse.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Sep 2007 13:31:06 -0700
In-Reply-To: <p73ps0b93ph.fsf@bingen.suse.de> (Andi Kleen's message of "21 Sep 2007 22:13:46 +0200")
Message-ID: <adar6kryd4l.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Sep 2007 20:31:06.0803 (UTC) FILETIME=[565FE830:01C7FC8E]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Just change the makefiles to always install gzip'ed modules
 > modutils knows how to unzip them on the fly.

But that leaves the uncompressed firmware blobs in .data that ends up
in unswappable kernel memory.

 - R.
