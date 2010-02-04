Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab0BDVph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:45:37 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:50833 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544Ab0BDVpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:45:35 -0500
To: opurdila@ixiacom.com, davem@davemloft.net
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, linux-sctp@vger.kernel.org
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201002031312.48531.opurdila@ixiacom.com>
	<201002041444.01897.opurdila@ixiacom.com>
	<20100204.094110.64247447.davem@davemloft.net>
	<201002042015.51092.opurdila@ixiacom.com>
In-Reply-To: <201002042015.51092.opurdila@ixiacom.com>
Message-Id: <201002050645.CEC95380.MLOtOVFFHSFOQJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 5 Feb 2010 06:45:28 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> 
> int inet_is_reserved_local_port(int port)
> {
> 	if (test_bit(port, reserved_ports))
> 		return 1;
> 	return 0;
> }
> 
Above check is exactly what I'm doing in the LSM hook.
