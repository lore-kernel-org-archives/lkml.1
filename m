Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbXISWoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbXISWoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXISWoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:44:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39786
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755236AbXISWoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:44:05 -0400
Date: Wed, 19 Sep 2007 15:44:02 -0700 (PDT)
Message-Id: <20070919.154402.34760338.davem@davemloft.net>
To: tomer_iisc@yahoo.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered
 EPOLLOUT events get missed for TCP sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <130356.85796.qm@web53703.mail.re2.yahoo.com>
References: <130356.85796.qm@web53703.mail.re2.yahoo.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nagendra Tomar <tomer_iisc@yahoo.com>
Date: Wed, 19 Sep 2007 15:37:09 -0700 (PDT)

> With the SOCK_NOSPACE check in tcp_check_space(), this epoll_wait call will 
> not return, even when the incoming acks free the buffers.
>         Note that this patch assumes that the SOCK_NOSPACE check in
> tcp_check_space is a trivial optimization which can be safely removed.

I already replied to your patch posting explaining that whatever is
not setting SOCK_NOSPACE should be fixed instead.

Please address that, thanks.
