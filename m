Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXGZHNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXGZHNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbXGZHMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:12:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45183
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759799AbXGZHMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:12:51 -0400
Date: Thu, 26 Jul 2007 00:12:50 -0700 (PDT)
Message-Id: <20070726.001250.18310187.davem@davemloft.net>
To: marcel@holtmann.org
Cc: bunk@stusta.de, ville.tervo@nokia.com, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: net/bluetooth/rfcomm/tty.c: use-after-free
From: David Miller <davem@davemloft.net>
In-Reply-To: <1185176832.7111.32.camel@violet>
References: <20070723012543.GW26212@stusta.de>
	<1185176832.7111.32.camel@violet>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 23 Jul 2007 09:47:12 +0200

> Hi Adrian,
> 
> > Commit 8de0a15483b357d0f0b821330ec84d1660cadc4e added the following 
> > use-after-free in net/bluetooth/rfcomm/tty.c:
 ...
> > Spotted by the Coverity checker.
> 
> really good catch. I fully overlooked that one. The attached patch
> should fix it.
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Applied, thanks everyone.
