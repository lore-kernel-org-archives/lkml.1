Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYHAGbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYHAGbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 02:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYHAGa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 02:30:57 -0400
Received: from stinky.trash.net ([213.144.137.162]:63806 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYHAGa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 02:30:57 -0400
Message-ID: <4892AD9E.2050109@trash.net>
Date: Fri, 01 Aug 2008 08:30:54 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Matt Kraai <kraai@ftbfs.org>
CC: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, stable@kernel.org
Subject: Re: [PATCH] netfilter: Move linux/in.h and linux/in6.h inclusions
 outside of #ifdef __KERNEL__
References: <20080731083525.GC7164@ftbfs.org>
In-Reply-To: <20080731083525.GC7164@ftbfs.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Kraai wrote:
> From: Matt Kraai <kraai@ftbfs.org>
> 
> netfilter.h can't be used in userspace without including linux/in.h
> and linux/in6.h first. netfilter.h includes its own linux/in.h and
> linux/in6.h include statements, these are stripped by make
> headers-install because they are inside #ifdef __KERNEL__ however.
> Move them out to fix this.

Applied, thanks.
