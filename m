Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZG1AT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZG1AT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZG1AT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:19:28 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:49384 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZG1AT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:19:27 -0400
Date: Tue, 28 Jul 2009 10:19:27 +1000
From: Simon Horman <horms@verge.net.au>
To: David Miller <davem@davemloft.net>
Cc: heder@google.com, netdev@vger.kernel.org, eric.dumazet@gmail.com,
       lvs-users@linuxvirtualserver.org, malcolm@loadbalancer.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] IPVS: logging sizeof(struct ip_vs_conn) on startup
Message-ID: <20090728001926.GA20230@verge.net.au>
Mail-Followup-To: David Miller <davem@davemloft.net>, heder@google.com,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	lvs-users@linuxvirtualserver.org, malcolm@loadbalancer.org,
	linux-kernel@vger.kernel.org
References: <4A6D7285.9080909@gmail.com> <b5ddba180907270334m4bc4e968m85c16ea4756c3f5d@mail.gmail.com> <20090727131357.9561.39720.stgit@jazzy.zrh.corp.google.com> <20090727.114845.177925839.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727.114845.177925839.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 11:48:45AM -0700, David Miller wrote:
> From: Hannes Eder <heder@google.com>
> Date: Mon, 27 Jul 2009 15:13:57 +0200
> 
> > No more guessing, how much memory used by IPVS for a connection.
> > 
> > [ The number printed is a lower bound, as ip_vs_conn_cache uses
> > SLAB_HWCACHE_ALIGN. ]
> > 
> > Signed-off-by: Hannes Eder <heder@google.com>
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Who needs to know this?  A developer?
> 
> They can run tools such as 'pahole' et al. to fish out this
> information even when only a kernel binary is available.
> 
> For the user, it's just noise.
> 
> I'm not applying this, sorry.

Surprisingly its a very common question amongst users,
because they want to know how much memory they need.
It is of course all a bit silly, because the amount of
memory used by the connection table is usually very small,
but people still ask.

