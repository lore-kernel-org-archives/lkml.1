Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYHGDXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYHGDXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYHGDUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:20:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50670
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbYHGDUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:20:38 -0400
Date: Wed, 06 Aug 2008 20:20:38 -0700 (PDT)
Message-Id: <20080806.202038.93643856.davem@davemloft.net>
To: guijianfeng@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add (struct sock*) sk parameter for send_ack()
From: David Miller <davem@davemloft.net>
In-Reply-To: <48981BDE.70201@cn.fujitsu.com>
References: <48981BDE.70201@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Date: Tue, 05 Aug 2008 17:22:38 +0800

> Add (struct sock*) sk parameter for send_ack.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

This patch by itself breaks the build.

Don't submit patches this way.  Every patch applied should
still leave the tree building.

Also, since your OOPS and detailed description only exists
in the "0/3" email, it won't make it into the commit log
history where it belongs.

Considering all of this, I'd say you should fix this as
one big patch with a really nice commit log message.

Thanks.
