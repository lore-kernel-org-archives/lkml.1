Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYBEKyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYBEKyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbYBEKyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:54:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59160
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756329AbYBEKyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:54:32 -0500
Date: Tue, 05 Feb 2008 02:55:00 -0800 (PST)
Message-Id: <20080205.025500.250150631.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: yoshfuji@linux-ipv6.org, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPV4: fix compile error building without CONFIG_FS_PROC
From: David Miller <davem@davemloft.net>
In-Reply-To: <47A68388.2030104@cn.fujitsu.com>
References: <47A660A1.5080504@cn.fujitsu.com>
	<20080204.132518.63717287.yoshfuji@linux-ipv6.org>
	<47A68388.2030104@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Mon, 04 Feb 2008 11:16:24 +0800

> compile error building without CONFIG_FS_PROC:
> 
> net/ipv4/fib_frontend.c: In function 'fib_net_init':
> net/ipv4/fib_frontend.c:1032: error: implicit declaration of function 'fib_proc_
> init'
> net/ipv4/fib_frontend.c: In function 'fib_net_exit':
> net/ipv4/fib_frontend.c:1047: error: implicit declaration of function 'fib_proc_
> exit'
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Applied, thanks.
