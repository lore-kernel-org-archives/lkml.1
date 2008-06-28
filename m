Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYF1DDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYF1DDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 23:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYF1DDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 23:03:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45941
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752177AbYF1DDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 23:03:40 -0400
Date: Fri, 27 Jun 2008 20:03:40 -0700 (PDT)
Message-Id: <20080627.200340.128759990.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: johnpol@2ka.mipt.ru, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] CONNECTOR: add a proc entry to list connectors
From: David Miller <davem@davemloft.net>
In-Reply-To: <4860B279.9070105@cn.fujitsu.com>
References: <4860B279.9070105@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Tue, 24 Jun 2008 16:38:17 +0800

> I got a problem when I wanted to check if the kernel supports process
> event connector, and It seems there's no way to do this check.
> 
> At best I can check if the kernel supports connector or not, by looking
> into /proc/net/netlink, or maybe checking the return value of bind() to
> see if it's ENOENT.
> 
> So it would be useful to add /proc/net/connector to list all supported
> connectors:
>  # cat /proc/net/connector
>  Name            ID
>  connector       4294967295:4294967295
>  cn_proc         1:1
>  w1              3:1
> 
> Changelog:
> - fix memory leak: s/seq_release/single_release
> - use spin_lock_bh instead of spin_lock_irqsave
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Applied, thanks.
