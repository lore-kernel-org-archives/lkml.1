Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbXHBKt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbXHBKt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXHBKtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:49:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37682 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXHBKtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:49:17 -0400
Date: Thu, 2 Aug 2007 12:49:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Herbert Rosmanith <kernel@wildsau.enemy.org>
cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <200708021042.l72AguIM008585@wildsau.enemy.org>
Message-ID: <Pine.LNX.4.64.0708021246200.24572@fbirervta.pbzchgretzou.qr>
References: <200708021042.l72AguIM008585@wildsau.enemy.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 12:42, Herbert Rosmanith wrote:
>
>hu. where are the days when eth0 was eth0 ...

If you and/or your distribution accidentally or incidentally loaded modules in
the wrong order (which may happen in e.g. parallel-running boot scripts), you
suddenly have eth0 as eth1. Or, when you changed the PCI slots (i.e. swapped
cards around), eth0 would also suddenly become a different one. There never
*were* days when eth0 remained eth0 across such changes.

>which translates:
>
>    "Haha, that's randy, that's like in Windows, which
>    notices that you've got a new mainboard"

In Linux, the user recognizes he got himself a new mainboard,
e.g. when the IDE chip changed and the new module is not in the initrd.



	Jan
-- 
