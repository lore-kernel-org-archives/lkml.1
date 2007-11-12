Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbXKLWqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbXKLWqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbXKLWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:46:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754738AbXKLWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:46:11 -0500
Date: Mon, 12 Nov 2007 14:46:10 -0800 (PST)
Message-Id: <20071112.144610.83838447.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: tony.luck@intel.com, clameter@sgi.com, herbert@gondor.apana.org.au,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <4738B437.1000204@cosmosbay.com>
References: <4738AE04.1030506@cosmosbay.com>
	<617E1C2C70743745A92448908E030B2A02EDFBB5@scsmsx411.amr.corp.intel.com>
	<4738B437.1000204@cosmosbay.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Mon, 12 Nov 2007 21:14:47 +0100

> I dont think this is a problem. Cpus numbers and ram size are related, even if 
> Moore didnt predicted it;
> 
> Nobody wants to ship/build a 4096 cpus machine with 256 MB of ram inside.
> Or call it a GPU and dont expect it to run linux :)
> 
> 99,9% of linux machines running on earth have less than 8 cpus and less than 
> 1000 ethernet/network devices.
> 
> In case we increase the number of cpus on a machine, the limiting factor is 
> the fact that cpus have to continually exchange on memory bus those highly 
> touched cache lines that contain refcounters or stats.

I totally agree with everything Eric is saying here.
