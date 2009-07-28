Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbZG1FjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbZG1FjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZG1FjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:39:10 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39862 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZG1FjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:39:09 -0400
Message-ID: <4A6E8EED.8050600@gmail.com>
Date: Tue, 28 Jul 2009 07:38:53 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: David Miller <davem@davemloft.net>, heder@google.com,
       netdev@vger.kernel.org, lvs-users@linuxvirtualserver.org,
       malcolm@loadbalancer.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] IPVS: logging sizeof(struct ip_vs_conn) on startup
References: <4A6D7285.9080909@gmail.com> <b5ddba180907270334m4bc4e968m85c16ea4756c3f5d@mail.gmail.com> <20090727131357.9561.39720.stgit@jazzy.zrh.corp.google.com> <20090727.114845.177925839.davem@davemloft.net> <20090728001926.GA20230@verge.net.au>
In-Reply-To: <20090728001926.GA20230@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 28 Jul 2009 07:38:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman a écrit :
> 
> Surprisingly its a very common question amongst users,
> because they want to know how much memory they need.
> It is of course all a bit silly, because the amount of
> memory used by the connection table is usually very small,
> but people still ask.
> 

If SLUB is used 

$ cat /sys/kernel/slab/ip_vs_conn/object_size

If SLAB is used, take fourth column of :

$ grep ip_vs_conn /proc/slabinfo

BTW these take into account L1 cache size alignment
