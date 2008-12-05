Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYLEPWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYLEPWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYLEPW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:22:26 -0500
Received: from stinky.trash.net ([213.144.137.162]:58380 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYLEPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:22:25 -0500
Message-ID: <4939472E.7060804@trash.net>
Date: Fri, 05 Dec 2008 16:22:22 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: davem@davemloft.net, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/netfilter: simplify error handling
References: <Pine.LNX.4.64.0812051234230.9560@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812051234230.9560@pc-004.diku.dk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> nf_conntrack_alloc cannot return NULL, so there is no need to check for
> NULL before using the value.  I have also removed the initialization of ct
> to NULL in nf_conntrack_alloc, since the value is never used, and since
> perhaps it might lead one to think that return ct at the end might return
> NULL.

Applied, thanks.

