Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXFLIJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXFLIJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXFLIIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:08:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60581
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbXFLIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:08:44 -0400
Date: Tue, 12 Jun 2007 01:08:55 -0700 (PDT)
Message-Id: <20070612.010855.51301101.davem@davemloft.net>
To: ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] CONFIG_INET depend on CONFIG_SYSCTL
From: David Miller <davem@davemloft.net>
In-Reply-To: <m2sl8xfwq8.wl%ysato@users.sourceforge.jp>
References: <m2sl8xfwq8.wl%ysato@users.sourceforge.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshinori Sato <ysato@users.sourceforge.jp>
Date: Tue, 12 Jun 2007 16:38:55 +0900

> It cannot build with CONFIG_SYSCTL=n and CONFIG_INET=y.
> In case of CONFIG_INET=y it should become CONFIG_SYSCTL=y. 
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>

1) Please post networking patches to netdev@vger.kernel.org
   which has been added to the CC:

2) It is much better to add the appropriate CONFIG_SYSCTL
   ifdefs to the INET code than to force it on for everyone.
