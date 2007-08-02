Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbXHBK4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbXHBK4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbXHBK4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:56:24 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:33100 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXHBK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:56:23 -0400
From: Herbert Rosmanith <kernel@wildsau.enemy.org>
Message-Id: <200708021056.l72Au722008603@wildsau.enemy.org>
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <Pine.LNX.4.64.0708021246200.24572@fbirervta.pbzchgretzou.qr>
To: Jan Engelhardt <jengelh@computergmbh.de>
Date: Thu, 2 Aug 2007 12:56:06 +0200 (MET DST)
CC: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Aug 2 2007 12:42, Herbert Rosmanith wrote:
> There never *were* days when eth0 remained eth0 across such changes.

but there *were* days when eth0 was eth0, if the kernel reports it as such.
now there is no eth0 at all. if I see an "eth0" from dmesg, I expect
it to be present.

Instead, udev remembers the old MAC address in 
    /etc/udev/rules.d/70-persistent-net.rules

which contains the old MAC adresses, too.

of course, that's problem with gentoo, not with the kernel.

Now I know why I never trusted udev much :-/

thanks,
herp

