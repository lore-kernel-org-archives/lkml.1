Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbXLQOsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbXLQOsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXLQOry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:47:54 -0500
Received: from stinky.trash.net ([213.144.137.162]:59316 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbXLQOrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:47:53 -0500
Message-ID: <47668BE9.8010504@trash.net>
Date: Mon, 17 Dec 2007 15:47:05 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Harald Welte <laforge@gnumonks.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] net/ipv4/netfilter/ip_tables.c: remove some inlines
References: <200712161247.53986.vda.linux@googlemail.com>
In-Reply-To: <200712161247.53986.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC netfilter-devel on netfilter patches.

Denys Vlasenko wrote:
> Hi Patrick, Harald,
> 
> I was working on unrelated problem and noticed that ip_tables.c
> seem to abuse inline. I prepared a patch which removes inlines
> except those which are used by packet matching code
> (and thus are really performance-critical).
> I added comments explaining that remaining inlines are
> performance critical.
> 
> Result as reported by size:
> 
>    text    data     bss     dec     hex filename
> -  6451     380      88    6919    1b07 ip_tables.o
> +  6339     348      72    6759    1a67 ip_tables.o
> 
> Please take this patch into netfilter queue.


This clashes with my pending patches, which I'll push upstream
today. I also spent some time resyncing ip_tables and ip6_tables
so a diff of both (with some sed'ing) shows only the actual
differences, so please update ip6_tables as well.

