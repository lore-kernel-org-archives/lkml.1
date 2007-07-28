Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbXG1QiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbXG1QiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXG1QiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:38:07 -0400
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:56117 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXG1QiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:38:06 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 12:38:06 EDT
Date: Sat, 28 Jul 2007 22:33:06 +0200
From: Edward Ando <edwardando@fastwebnet.it>
To: linux-kernel@vger.kernel.org
Subject: Removing the prism54 module
Message-ID: <20070728223306.786b47a9@ed.anywhere>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,
I am trying to set up software suspend 2 (TuxOnIce now it seems). This
has decided it wants to remove the prism54 module before starting the
hibernate process.

When it tries to do this, (or when I manually do: "ifconfig eth1
down"), I start getting these messages on all terminals, ad infinitum:

kernel: unregister_netdevice: waiting for eth1 to become free. Usage
count = 4

I asked a bit on #prism54 on freenode, and so I upgraded to
linux 2.6.22.1 from kernel.org, always building prism54 as a module,
but the problem continues.

I have tried doing "ifconfig eth1 down" before rmmod, but this does not
help.

If you have any hints or answers as to what I should do, that would be
great. I think I have subscribed successfully to this mailing list, but
any CCs to this address are also welcome.

Thanks in advance,
Yours,

Edward Ando
