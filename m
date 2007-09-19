Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbXISXKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbXISXKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbXISXKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:10:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52542
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbXISXKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:10:37 -0400
Date: Wed, 19 Sep 2007 16:10:37 -0700 (PDT)
Message-Id: <20070919.161037.68156707.davem@davemloft.net>
To: tomer_iisc@yahoo.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered
 EPOLLOUT events get missed for TCP sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <640879.56443.qm@web53701.mail.re2.yahoo.com>
References: <20070919.154402.34760338.davem@davemloft.net>
	<640879.56443.qm@web53701.mail.re2.yahoo.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nagendra Tomar <tomer_iisc@yahoo.com>
Date: Wed, 19 Sep 2007 15:55:58 -0700 (PDT)

>      I agree that setting SOCK_NOSPACE would have been a more elegant
> fix. Infact I thought a lot about that before deciding on this fix.

I guess this means you also noticed that you are removing
the one and only test of this bit too?

You can't remove this, it's critical for performance.
