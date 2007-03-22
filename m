Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbXCVSE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbXCVSE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934175AbXCVSE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:04:59 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:19058 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934174AbXCVSE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:04:58 -0400
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       openib-general@openib.org
Subject: Re: [ofa-general] drivers/infiniband/ulp/ipoib/ipoib_main.c: use-after-free
X-Message-Flag: Warning: May contain useful information
References: <20070319092310.GJ752@stusta.de>
	<20070319094619.GE8386@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 22 Mar 2007 11:04:51 -0700
In-Reply-To: <20070319094619.GE8386@mellanox.co.il> (Michael S. Tsirkin's message of "Mon, 19 Mar 2007 11:46:19 +0200")
Message-ID: <adaodmlf930.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Mar 2007 18:04:51.0840 (UTC) FILETIME=[967E9000:01C76CAC]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Something like this then? Untested.

Looks right to me, and seems to work.  So I'll apply this.

 - R.
