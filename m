Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbXFOSmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbXFOSmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXFOSmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:42:00 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:32461 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbXFOSl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:41:59 -0400
X-IronPort-AV: i="4.16,425,1175497200"; 
   d="scan'208"; a="379838376:sNHT686728534"
To: "jidong xiao" <jidong.xiao@gmail.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to printk unsigned long long variable?
X-Message-Flag: Warning: May contain useful information
References: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
	<19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com>
	<20070615083355.f5bdb784.randy.dunlap@oracle.com>
	<4104961b0706150839t1a54ccdaq4ddc747d04538a19@mail.gmail.com>
	<adaabv1i49q.fsf@cisco.com>
	<4104961b0706150918me1d809fu66ee07738284c21c@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 15 Jun 2007 11:41:58 -0700
In-Reply-To: <4104961b0706150918me1d809fu66ee07738284c21c@mail.gmail.com> (jidong xiao's message of "Sat, 16 Jun 2007 00:18:09 +0800")
Message-ID: <ada1wgdhxft.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jun 2007 18:41:58.0285 (UTC) FILETIME=[DAABDBD0:01C7AF7C]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > dma_mask should be a pointer, I mean, the element in struct device, see below,

Sorry, you're right.

So print it as (unsigned long long) *dev->dma_mask.

 - R.
