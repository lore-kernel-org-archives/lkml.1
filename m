Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZH2Njn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZH2Njn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZH2Njl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:39:41 -0400
Received: from smtp.knology.net ([24.214.63.101]:37958 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZH2Njk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:39:40 -0400
Subject: Re: r8169 NETDEV WATCHDOG: eth0: transmit timed out [0/8]
From: David Dillow <dave@thedillows.org>
To: roma1390 <roma1390@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <b410963b0908290216x19206aa6o4458bb55b5578a04@mail.gmail.com>
References: <b410963b0908290216x19206aa6o4458bb55b5578a04@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 29 Aug 2009 09:39:40 -0400
Message-Id: <1251553180.13707.16.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-29 at 12:16 +0300, roma1390 wrote:
> Using 3 different r8169 devices on 2 servers (from 2 server so 100% of
> population) we getting
> 
> NETDEV WATCHDOG: eth0: transmit timed out

You're running an old version of the kernel, and the driver was patched
to fix that issue in 2.6.30. It is also in the 2.6.29.x stable series,
and I think maybe the 2.6.28.x series -- please try those and see if you
problem is resolved.

We're aware of a possible issue with the fix in those kernels, and are
working it in another thread. A quick search of the archives should turn
it up. Will you be willing to test patches?

>From your dmesg, it looks like you have 8169c's, running in MSI mode.
Can you please confirm this by sending your /proc/interrupt info:
	cat /proc/interrupts | grep eth0

Also, in the future, please cc netdev on network bug reports.
Thanks!

