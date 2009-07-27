Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZG0Ssj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZG0Ssj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZG0Ssj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:48:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57263
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbZG0Ssi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:48:38 -0400
Date: Mon, 27 Jul 2009 11:48:45 -0700 (PDT)
Message-Id: <20090727.114845.177925839.davem@davemloft.net>
To: heder@google.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com,
       lvs-users@linuxvirtualserver.org, malcolm@loadbalancer.org,
       linux-kernel@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH v2] IPVS: logging sizeof(struct ip_vs_conn) on startup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090727131357.9561.39720.stgit@jazzy.zrh.corp.google.com>
References: <4A6D7285.9080909@gmail.com>
	<b5ddba180907270334m4bc4e968m85c16ea4756c3f5d@mail.gmail.com>
	<20090727131357.9561.39720.stgit@jazzy.zrh.corp.google.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <heder@google.com>
Date: Mon, 27 Jul 2009 15:13:57 +0200

> No more guessing, how much memory used by IPVS for a connection.
> 
> [ The number printed is a lower bound, as ip_vs_conn_cache uses
> SLAB_HWCACHE_ALIGN. ]
> 
> Signed-off-by: Hannes Eder <heder@google.com>
> Signed-off-by: Simon Horman <horms@verge.net.au>

Who needs to know this?  A developer?

They can run tools such as 'pahole' et al. to fish out this
information even when only a kernel binary is available.

For the user, it's just noise.

I'm not applying this, sorry.
