Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZKKEky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZKKEky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 23:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbZKKEkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 23:40:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34065
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756755AbZKKEkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 23:40:52 -0500
Date: Tue, 10 Nov 2009 20:41:18 -0800 (PST)
Message-Id: <20091110.204118.12070030.davem@davemloft.net>
To: arnd@arndb.de
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       eric.dumazet@gmail.com
Subject: Re: [PATCH, WTF] atm: move all compat_ioctl handling to atm/ioctl.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <200911061500.01651.arnd@arndb.de>
References: <200911061500.01651.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I agree that this should be done in one place, rather than split up
like it is now.  Can you please respin your changes against
net-next-2.6 since the code you are changing here is no longer in
fs/compat_ioctl.c due to your other patch set?

Thanks.
