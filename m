Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXFMGFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXFMGFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXFMGF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:05:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37098
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753494AbXFMGF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:05:29 -0400
Date: Tue, 12 Jun 2007 23:05:45 -0700 (PDT)
Message-Id: <20070612.230545.104645806.davem@davemloft.net>
To: ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] CONFIG_INET depend on CONFIG_SYSCTL
From: David Miller <davem@davemloft.net>
In-Reply-To: <m2abv41jkb.wl%ysato@users.sourceforge.jp>
References: <m2sl8xfwq8.wl%ysato@users.sourceforge.jp>
	<20070612.010855.51301101.davem@davemloft.net>
	<m2abv41jkb.wl%ysato@users.sourceforge.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshinori Sato <ysato@users.sourceforge.jp>
Date: Wed, 13 Jun 2007 14:59:16 +0900

> At Tue, 12 Jun 2007 01:08:55 -0700 (PDT),
> David Miller wrote:
>  
> > 2) It is much better to add the appropriate CONFIG_SYSCTL
> >    ifdefs to the INET code than to force it on for everyone.
> 
> It examined that, but many corrections become necessary.

I understand, but embedded people will not be happy that
SYSFS is a requirement for IPV4 networking.  Every little
bit of space savings matters for them.
