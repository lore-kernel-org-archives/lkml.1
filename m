Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYBERi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYBERi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYBERiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:38:16 -0500
Received: from s36.avahost.net ([74.53.95.194]:58262 "EHLO s36.avahost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYBERiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:38:15 -0500
Message-ID: <47A89F02.8010403@katalix.com>
Date: Tue, 05 Feb 2008 17:38:10 +0000
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Rami Rosen <ramirose@gmail.com>
CC: netdev@vger.kernel.org, jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PPPOL2TP] Label unused warning when CONFIG_PROC_FS is
 not set.
References: <eb3ff54b0802050415h3c4672b1r7048143b599303dd@mail.gmail.com>
In-Reply-To: <eb3ff54b0802050415h3c4672b1r7048143b599303dd@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s36.avahost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - katalix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: James Chapman <jchapman@katalix.com>

Rami Rosen wrote:
> Hi,
> 
> When CONFIG_PROC_FS is not set and CONFIG_PPPOL2TP is set,
> we have the following warning in build:
>   drivers/net/pppol2tp.c: In function 'pppol2tp_init':
>   drivers/net/pppol2tp.c:2472: warning: label
> 'out_unregister_pppox_proto' defined but not used
> 
> This patches fixes this warning by adding appropriate #ifdef.
> 
> Regards,
> Rami Rosen
> 
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
> 


-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

