Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbYBESWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbYBESWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYBESWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:22:23 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41932 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbYBESWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:22:22 -0500
Message-ID: <47A8A95B.4060905@garzik.org>
Date: Tue, 05 Feb 2008 13:22:19 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rami Rosen <ramirose@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] [PPPOL2TP] Label unused warning when CONFIG_PROC_FS is
 not set.
References: <eb3ff54b0802050415h3c4672b1r7048143b599303dd@mail.gmail.com>
In-Reply-To: <eb3ff54b0802050415h3c4672b1r7048143b599303dd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


David or Paul, wanna pick this up?

