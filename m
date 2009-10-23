Return-Path: <linux-kernel-owner+w=401wt.eu-S1751347AbZJWB2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbZJWB2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZJWB2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:28:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57958
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbZJWB2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:28:21 -0400
Date: Thu, 22 Oct 2009 18:28:44 -0700 (PDT)
Message-Id: <20091022.182844.11139590.davem@davemloft.net>
To: xtfeng@gmail.com
Cc: isdn@linux-pingi.de, isdn4linux@listserv.isdn4linux.de, tilman@imap.cc,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: fix possible circular locking dependency
From: David Miller <davem@davemloft.net>
In-Reply-To: <1256202424-28314-1-git-send-email-xtfeng@gmail.com>
References: <1256202424-28314-1-git-send-email-xtfeng@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <xtfeng@gmail.com>
Date: Thu, 22 Oct 2009 17:07:04 +0800

> There's a circular locking dependency:
 ...
>  We don't need to lock nd->queue->xmit_lock to protect single
> isdn_net_lp_busy(). This can fix above lockdep warnings.
> 
> Reported-and-tested-by: Tilman Schmidt <tilman@imap.cc>
> Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>

Applied, thanks.
