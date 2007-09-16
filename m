Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbXIPXhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbXIPXhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 19:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbXIPXgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 19:36:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55967
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbXIPXgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 19:36:50 -0400
Date: Sun, 16 Sep 2007 16:36:50 -0700 (PDT)
Message-Id: <20070916.163650.88475186.davem@davemloft.net>
To: crquan@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: Re: [PATCH 2/3] netlink: the temp variable name max is ambiguous
From: David Miller <davem@davemloft.net>
In-Reply-To: <11886759682348-git-send-email-crquan@gmail.com>
References: <1188675959178-git-send-email-crquan@gmail.com>
	<11886759682348-git-send-email-crquan@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Sun,  2 Sep 2007 03:45:58 +0800

> with the macro max provided by <linux/kernel.h>, so changed its name to a more proper one: limit
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Not strictly necessary because CPP knows to differentiate between
'max(' and plain 'max' when evaluating if a CPP macro should be
expanded or not.

Nonetheless, applied to net-2.6.24, thanks.
