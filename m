Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540Ab0AFIkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0AFIkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 03:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492Ab0AFIkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 03:40:35 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:60828 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469Ab0AFIke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 03:40:34 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: Bryan Donlan <bdonlan@gmail.com>
cc: Anders Eriksson <aeriksson@fastmail.fm>, Yinghai Lu <yinghai@kernel.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Memory probing fails after 2.6.30 (bisected)
In-reply-to: <3e8340491001051359m799df6bai86ec42dfff96f0f0@mail.gmail.com>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org> <86802c441001051102j547f10bga2b40fbaee9cf623@mail.gmail.com> <20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org> <3e8340491001051359m799df6bai86ec42dfff96f0f0@mail.gmail.com>
Comments: In-reply-to Bryan Donlan <bdonlan@gmail.com>
   message dated "Tue, 05 Jan 2010 16:59:27 -0500."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 06 Jan 2010 09:38:28 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100106083828.8111A33C5F5@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.238.172
X-Scan-Result: No virus found in message 1NSRRO-0004UH-3Q.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1NSRRO-0004UH-3Q ee912131fe27f3f688a9340fcce2bd8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bdonlan@gmail.com said:
> Looks like the boot succeeded, at least long enough to mount the root fs.
> Assuming you're not using bootsplash or something, you should have seen
> something. Are you sure this is the log from the failed boot? If it didn't
> make it to userspace, it won't leave anything in kern.log. 

Yes I am.

2.6.31 --> instant reboot. Not one line of printk on the screen.
35d5a9a61490bf39d2e48d7f499c8c801a39ebe9 and 'lower' --> Get a 16 16MB env 
which didn't boot.

I got clued up and booted with init=/bin/bash, so for the fingered commit 
(i.e. the one switching from all-happy e820 to bios-88), I managed to 
remount / rw and capture dmesg.

Not sure how that interacts with earlyprintk=vga though. Did I get everyting 
there is to get?

-A

