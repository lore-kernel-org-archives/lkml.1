Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbXGXRLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbXGXRLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbXGXRLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:11:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:30239 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbXGXRLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:11:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,574,1175497200"; 
   d="scan'208";a="272125597"
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
From: "Li, Tong N" <tong.n.li@intel.com>
To: Chris Snook <csnook@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <46A5B35F.90103@redhat.com>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
	 <46A53C88.6060006@redhat.com>  <46A5B35F.90103@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Jul 2007 10:11:07 -0700
Message-Id: <1185297067.7737.5.camel@tongli.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 24 Jul 2007 17:11:08.0145 (UTC) FILETIME=[A03EBE10:01C7CE15]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 04:07 -0400, Chris Snook wrote:

> To clarify, I'm not suggesting that the "balance with cpu (x+1)%n only" 
> algorithm is the only way to do this.  Rather, I'm pointing out that 
> even an extremely simple algorithm can give you fair loading when you 
> already have CFS managing the runqueues.  There are countless more 
> sophisticated ways we could do this without using global locking, or 
> possibly without any locking at all, other than the locking we already 
> use during migration.
> 
> 	-- Chris

Yes, as Andi and Chris also pointed out, I'll think about if global
synchronization can be removed or relaxed.

Thanks,

  tong
