Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYKCWIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYKCWIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYKCWIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:08:05 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52880 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbYKCWIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:08:04 -0500
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <B9DCBB9E-9DE3-4114-9FFC-7A7C0C3DA920@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20081103205121.GA6005@havoc.gtf.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [git patches] net driver fixes for 2.6.28-rc
Date: Mon, 3 Nov 2008 23:07:58 +0100
References: <20081103205121.GA6005@havoc.gtf.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> Please pull from 'davem-fixes' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git  
> davem-fixes
>
> to receive the following updates:
>
> drivers/net/Kconfig                |   18 +++++++++++++++---
> drivers/net/fs_enet/fs_enet-main.c |    6 ++++--
> drivers/net/mv643xx_eth.c          |    9 ++++++---
> 3 files changed, 25 insertions(+), 8 deletions(-)

are you also queuing patches for drivers/net/usb/hso.c, because the  
current state of that driver is fully broken. It oopses and shows up  
with a WLAN RFKILL switch instead of WWAN. Also it has some weird  
disconnect race with the TTY layer. Some patches have been posted, but  
seems that nobody has picked them up so far.

Regards

Marcel

