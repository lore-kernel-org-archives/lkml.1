Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYHGFsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYHGFsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 01:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYHGFrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 01:47:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56160
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbYHGFrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 01:47:07 -0400
Date: Wed, 06 Aug 2008 22:47:08 -0700 (PDT)
Message-Id: <20080806.224708.172981191.davem@davemloft.net>
To: guijianfeng@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix kernel panic when calling tcp_v(4/6)_md5_do_lookup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080806.224411.210555962.davem@davemloft.net>
References: <489A8459.1020909@cn.fujitsu.com>
	<20080806.224411.210555962.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 06 Aug 2008 22:44:11 -0700 (PDT)

> Applied, thanks.

Actually I'm reverting, this was not properly build tested:

net/dccp/ipv4.c:555: warning: initialization from incompatible pointer type
net/dccp/ipv6.c:358: warning: initialization from incompatible pointer type
