Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0BEMJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:09:21 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:26009 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755122Ab0BEMJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:09:19 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Date: Fri, 5 Feb 2010 14:05:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-trunk-686; KDE/4.3.2; i686; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, linux-rdma@vger.kernel.org,
       netdev@vger.kernel.org, nhorman@tuxdriver.com,
       linux-sctp@vger.kernel.org
References: <201002031312.48531.opurdila@ixiacom.com> <201002042015.51092.opurdila@ixiacom.com> <4B6BA272.4090405@redhat.com>
In-Reply-To: <4B6BA272.4090405@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002051405.54029.opurdila@ixiacom.com>
X-OriginalArrivalTime: 05 Feb 2010 12:09:17.0818 (UTC) FILETIME=[0A9465A0:01CAA65C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 February 2010 06:45:38 you wrote:

> Again, using bitmap algorithm is not a problem and it's better, the
> problem is sysctl interface, how would you plan to interact with users
> via sysctl/proc if you use bitmap to handle this? I would like to hear
> more details about this.
> 

We could use something like positive values for setting and negative for reset 
(e.g. 3 would set the port in the bitmap and -3 would reset it).

But we would need new sysctl and proc handlers to handle the bitmap case (e.g. 
sysctl_bitmap, proc_dobitmap_minmax).
