Return-Path: <linux-kernel-owner+w=401wt.eu-S940313AbXGSSNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940313AbXGSSNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 14:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbXGSSM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 14:12:57 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:52100 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbXGSSM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 14:12:56 -0400
Message-ID: <469FA94E.20002@googlemail.com>
Date: Thu, 19 Jul 2007 20:11:26 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
>
>
> top is 275afcac9953ece0828972edeab9684cfe1a5ef3, error is:
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `store_uevent':
> core.c:(.text+0x20ebb): undefined reference to `kobject_actions'
> core.c:(.text+0x20edd): undefined reference to `kobject_actions'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [_all] Error 2
>
> .config attached. Is it because of CONFIG_HOTPLUG=n?
>   

Don't know but I got the same with randconfig today.

http://lkml.org/lkml/2007/7/19/349

>
> 	Jan

Gabriel
