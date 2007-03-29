Return-Path: <linux-kernel-owner+w=401wt.eu-S934321AbXC2Sue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934321AbXC2Sue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934323AbXC2Sue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:50:34 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2840 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934321AbXC2Sue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:50:34 -0400
From: Mariusz =?utf-8?q?Koz=C5=82owski?= <m.kozlowski@tuxland.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc5-mm1
Date: Thu, 29 Mar 2007 21:02:56 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Matt Mackall <mpm@selenic.com>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <200703292045.13140.m.kozlowski@tuxland.pl> <20070329183857.GA13362@elte.hu>
In-Reply-To: <20070329183857.GA13362@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703292102.56503.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > This is verified and repeatable _every_ single time I tried. 
> > > > Unfortunately the last thing seen on the screen before system is 
> > > > frozen is 'eth0: link down'. So my guess is that when hunting for 
> > > > hangs I found something else that can hang my laptop (netconsole 
> > > > that is).
> > > 
> > > fix-sysfs-reclaim-crash.patch is known-bad.  Did you try reverting 
> > > that?
> > 
> > Yes, just tested it. Sorry. It doesn't change anything.
> 
> could you try a !CONFIG_SMP kernel to make sure it's not some 
> self-locking of netconsole that is interfering? (Is it perhaps the 
> 'eth0: link down' message that is trigger from within netconsole?)

This is from .config:

# CONFIG_SMP is not set

Can this be that 'link down' is emitted by netconsole when the link is
already down and kernel gets locked? Does it make any sense?

	Mariusz
