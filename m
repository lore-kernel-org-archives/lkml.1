Return-Path: <linux-kernel-owner+w=401wt.eu-S1760919AbXISQCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919AbXISQCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbXISQC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:02:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59368
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754793AbXISQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:02:25 -0400
Date: Wed, 19 Sep 2007 09:02:09 -0700 (PDT)
Message-Id: <20070919.090209.73655853.davem@davemloft.net>
To: tomer_iisc@yahoo.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc6] NETWORKING : Edge Triggered EPOLLOUT events
 get missed for TCP sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <106538.13069.qm@web53707.mail.re2.yahoo.com>
References: <106538.13069.qm@web53707.mail.re2.yahoo.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nagendra Tomar <tomer_iisc@yahoo.com>
Date: Wed, 19 Sep 2007 04:13:24 -0700 (PDT)

> With the SOCK_NOSPACE check in tcp_check_space(), this epoll_wait call will 
> not return, even when the incoming acks free the buffers.
>         Note that this patch assumes that the SOCK_NOSPACE check in
> tcp_check_space is a trivial optimization which can be safely removed.

I think the more correct fix is to fix whoever isn't
setting the SOCK_NOSPACE bit, that check really is
crucial.
