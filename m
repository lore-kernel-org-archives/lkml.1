Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0CDW1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:27:11 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39426 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0CDW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:27:10 -0500
Date: Thu, 4 Mar 2010 23:27:08 +0100
From: Andreas Mohr <andi@lisas.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org, greg@kroah.com,
       x0082077@ti.com, sshtylyov@ru.mvista.com, benh@kernel.crashing.org,
       bigeasy@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100304222708.GA21205@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304163023.GC13417@n2100.arm.linux.org.uk>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is a program which Lothar sent me some time ago (the timestamp on
> the .c is June 2004 - I can't find the original email though.)  I've
> just checked with Lothar, who has given me permission to reproduce it.
> 
> I can't guarantee that this program still shows a problem - since I
> believe I've never been able to reproduce it myself.  It might be worth
> checking how other architectures behave.

Tried this on my BCM4710 MIPSEL 2.6.31.9 OpenWrt/Debian (problematic
cache-suspected history due to possibly related USB-audio lockups),
/dev/sda3 ext2 on an USB stick, no errors here, even when increasing tenfold
to 2560 and adding a sleep(2) in between.

Will investigate these things for real sometime later.

Andreas Mohr

P.S.: KARO (Lothar...) makes very nice boards :-)
