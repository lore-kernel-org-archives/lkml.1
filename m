Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbYBBLQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbYBBLQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYBBLQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:16:20 -0500
Received: from stinky.trash.net ([213.144.137.162]:39686 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYBBLQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:16:19 -0500
Message-ID: <47A450FD.5010006@trash.net>
Date: Sat, 02 Feb 2008 12:16:13 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Jiri Moravec <jim.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Typo in net/netfilter/xt_iprange.c (git tree)
References: <47A32BEB.9040008@gmail.com>
In-Reply-To: <47A32BEB.9040008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Moravec wrote:
> Function iprange_mt4 belong to IPv4 family - AF_INET. Right?
> 
> 	.name      = "iprange",
> 	.revision  = 1,
> 	.family    = AF_INET6, <---------- Typo?
> 	.match     = iprange_mt4,

Fixed, thanks Jiri.
