Return-Path: <linux-kernel-owner+w=401wt.eu-S934957AbXGQRyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934957AbXGQRyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762909AbXGQRxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:53:53 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55870 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793AbXGQRxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:53:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CACeenEarR7PE/2dsb2JhbAA
X-IronPort-AV: i="4.16,546,1175497200"; 
   d="scan'208"; a="167023593:sNHT105814989"
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	<20070713054711.GA21709@mellanox.co.il> <adar6nc2mt4.fsf@cisco.com>
	<20070714175425.GA17597@mellanox.co.il> <adabqecxpte.fsf@cisco.com>
	<20070716200540.GA8527@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 10:53:50 -0700
In-Reply-To: <20070716200540.GA8527@mellanox.co.il> (Michael S. Tsirkin's message of "Mon, 16 Jul 2007 23:05:40 +0300")
Message-ID: <adahco2syq9.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2007 17:53:50.0745 (UTC) FILETIME=[6EC83890:01C7C89B]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Well, the only issue I recall is about the # of EQs we want to allocate.
 > Was there something else?

Yes, some ideas about how applications should pick which EQ to use.
And how to handle CPU affinity.  And whether we want to try to do
something NUMA-aware.

 - R.
