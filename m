Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXLDWXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXLDWXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXLDWXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:23:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:52529 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbXLDWXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CYGZVolEE2PVAFwu6BYMjd8fq7nbn9mvST6nxN6Le3hoDcT0Pui0LMGYuJFnVSkHX5PpQdtFRGX3rnjuKBMG0vnjZxrgkN3qCHNl3uo/Edf0BTFk/FNLsYG1Chj9mD7OExpYCNKPHvzZZBlcuSFz3LNj8O1W1LwPewxzXm8m7lk=
Message-ID: <4755D42E.7050602@gmail.com>
Date: Tue, 04 Dec 2007 23:26:54 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Joonwoo Park <joonwpark81@gmail.com>
CC: netdev@vger.kernel.org,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: NET: ASSERT_RTNL in __dev_set_promiscuity makes debug warning
References: <000001c8365a$e0e500c0$9c94fea9@jason>
In-Reply-To: <000001c8365a$e0e500c0$9c94fea9@jason>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonwoo Park wrote, On 12/04/2007 10:48 AM:

> Hi,
> dev_set_rx_mode calls __dev_set_rx_mode with softirq disabled (by netif_tx_lock_bh)
> therefore __dev_set_promiscuity can be called with softirq disabled.
> It will cause in_interrupt() to return true and ASSERT_RTNL warning.
> Is there a good solution to fix it besides blowing ASSERT_RTNL up?


Fixing ASSERT_RTNL up?!

But, IMHO, blowing ASSERT_RTNL up in a few places shouldn't be much
worse. After all, how long such a debugging code should be kept. It
seems, at least sometimes we should be a bit more confident of how
it's called.

Regards,
Jarek P.
