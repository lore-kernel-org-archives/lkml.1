Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbXHBLMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbXHBLMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXHBLM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:12:27 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:33105 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbXHBLM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:12:27 -0400
From: Herbert Rosmanith <kernel@wildsau.enemy.org>
Message-Id: <200708021112.l72BCAW0008626@wildsau.enemy.org>
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <Pine.LNX.4.64.0708021246200.24572@fbirervta.pbzchgretzou.qr>
To: Jan Engelhardt <jengelh@computergmbh.de>
Date: Thu, 2 Aug 2007 13:12:10 +0200 (MET DST)
CC: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > cards around), eth0 would also suddenly become a different one. There never
> > *were* days when eth0 remained eth0 across such changes.
> 
> but there *were* days when eth0 was eth0, if the kernel reports it as such.
> now there is no eth0 at all. if I see an "eth0" from dmesg, I expect
> it to be present.

hm, well, a thought, maybe udev should report what is doing, like
printinig "renamed eth0 to eth2", or such.

the problem with this device renaming in my case was that other software,
in particular dhcpcd, didnt get any lease, because (obviously?) dhcpcd
on the other hand _still_ seemed to look for eth0, and thus, after
booting, there was no network configured at all.

Maybe the name "eth0" is hardcoded in the gentoo init scripts, I dont know.

Can this be considered a distrubtion bug?

cheers,
herp
