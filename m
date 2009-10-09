Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbZJIQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbZJIQcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933938AbZJIQcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:32:16 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43274 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933AbZJIQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:32:15 -0400
Message-ID: <4ACF6562.9040109@gmail.com>
Date: Fri, 09 Oct 2009 18:31:30 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: thomas@wytron.com.tw, netdev@vger.kernel.org,
       thierry.reding@avionic-design.de, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add netdev_alloc_skb_ip_align() helper
References: <1254969161-3609-1-git-send-email-thomas@wytron.com.tw>	<4ACD585B.5080106@gmail.com> <20091007.224036.247820677.davem@davemloft.net>
In-Reply-To: <20091007.224036.247820677.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 09 Oct 2009 18:31:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :

> Looks ok, but I want to look at how often this exact sequence
> would match.  If it applies to a lot of cases, I'll add this
> but I know of many exceptions in my head already :-)

Well, it was more as a reference. I believe about 20-30 call sites
could use it. Do you want me to provide a combo patch ?

