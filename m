Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZC0W4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZC0W4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZC0Wz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:55:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37021
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752597AbZC0Wz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:55:57 -0400
Date: Fri, 27 Mar 2009 15:55:45 -0700 (PDT)
Message-Id: <20090327.155545.238803642.davem@davemloft.net>
To: dmitri.vorobiev@movial.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Add missing include into include/linux/netdevice.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1238150213-30416-1-git-send-email-dmitri.vorobiev@movial.com>
References: <1238150213-30416-1-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Date: Fri, 27 Mar 2009 12:36:53 +0200

> The inline function skb_gro_mac_header defined in include/linux/netdevice.h
> makes use of page_address(). Depending on configuration options, the latter
> is either defined as a macro or is declared as a function in another header
> file, namely include/linux/mm.h. However, include/linux/netdevice.h does not
> include include/linux/mm.h.
> 
> On MIPS, this has produced the following build error:

Applied, thanks.
