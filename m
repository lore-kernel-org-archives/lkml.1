Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZIBBT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZIBBT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 21:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZIBBT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 21:19:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43265
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755493AbZIBBT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 21:19:58 -0400
Date: Tue, 01 Sep 2009 18:20:13 -0700 (PDT)
Message-Id: <20090901.182013.173315496.davem@davemloft.net>
To: xiaoguangrong@cn.fujitsu.com
Cc: nhorman@tuxdriver.com, yjwei@cn.fujitsu.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] drop_monitor: fix trace_napi_poll_hit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A9B6963.5090207@cn.fujitsu.com>
References: <4A9B6963.5090207@cn.fujitsu.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Date: Mon, 31 Aug 2009 14:10:43 +0800

> The net_dev of backlog napi is NULL, like below:
> 
> __get_cpu_var(softnet_data).backlog.dev == NULL
> 
> So, we should check it in napi tracepoint's probe function
> 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Applied to net-next-2.6, thanks.
