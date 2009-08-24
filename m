Return-Path: <linux-kernel-owner+w=401wt.eu-S1751351AbZHXCtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbZHXCtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 22:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZHXCtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 22:49:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48215
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbZHXCts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 22:49:48 -0400
Date: Sun, 23 Aug 2009 19:50:01 -0700 (PDT)
Message-Id: <20090823.195001.129946655.davem@davemloft.net>
To: Dongdong.deng@windriver.com
Cc: mpm@selenic.com, nico@cam.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jason.wessel@windriver.com
Subject: Re: [PATCH 1/2] netpoll: warning for ndo_start_xmit returns with
 interrupts enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <1250861616.24178.20.camel@dengdd-desktop>
References: <1250861616.24178.20.camel@dengdd-desktop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: DDD <Dongdong.deng@windriver.com>
Date: Fri, 21 Aug 2009 21:33:36 +0800

> WARN_ONCE for ndo_start_xmit() enable interrupts in netpoll_send_skb(),
> because the NETPOLL API requires that interrupts remain disabled in
> netpoll_send_skb().
> 
> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>

Applied.
