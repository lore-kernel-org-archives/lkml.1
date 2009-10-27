Return-Path: <linux-kernel-owner+w=401wt.eu-S932084AbZJ0SFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbZJ0SFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZJ0SFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:05:19 -0400
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:15702 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756518AbZJ0SFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:05:19 -0400
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] net: fold network name hash
Date: Tue, 27 Oct 2009 20:02:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-trunk-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk
References: <9986527.24561256620662709.JavaMail.root@tahiti.vyatta.com> <20091026.222428.80364204.davem@davemloft.net> <20091027102251.244ee681@nehalam>
In-Reply-To: <20091027102251.244ee681@nehalam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910272002.25384.opurdila@ixiacom.com>
X-OriginalArrivalTime: 27 Oct 2009 18:05:23.0134 (UTC) FILETIME=[0D9425E0:01CA5730]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 October 2009 19:22:51 you wrote:

> The full_name_hash does not produce a value that is evenly distributed
> over the lower 8 bits. This causes name hash to be unbalanced with large
> number of names.  A simple fix is to just fold in the higher bits
> with XOR.
> 
> This is independent of possible improvements to full_name_hash()
> in future.
> 

I can confirm that the distribution looks good now for our most common cases. 

Thanks,
tavi
