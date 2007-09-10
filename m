Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbXIJMhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbXIJMhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbXIJMg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:36:58 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:41865
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757462AbXIJMg5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:36:57 -0400
Date: Mon, 10 Sep 2007 05:36:42 -0700 (PDT)
Message-Id: <20070910.053642.71114977.davem@davemloft.net>
To: kovedi@gmail.com
Cc: linux-kernel@vger.kernel.org, stable-bounces@kernel.org,
       davem@sunset.davemloft.net
Subject: Re: [Sparc64 BUG] hangup under booting 2.6.22.X whith Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <406fe6c90709100442j1ae0ef79v3188eb10b8be451b@mail.gmail.com>
References: <406fe6c90709100442j1ae0ef79v3188eb10b8be451b@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kövedi_Krisztián" <kovedi@gmail.com>
Date: Mon, 10 Sep 2007 13:42:43 +0200

> Executing last command: boot
> Boot device: /pci@1f,0/ide@d/disk@0,0:a  File and args:
> SILO Version 1.4.13
> boot: teszt
> Allocated 8 Megs of memory at 0x40000000 for kernel
> Loaded kernel version 2.6.22
> 
> Remapping the kernel... done.
> Booting Linux...

Please add "-p" to the boot command line so we can see
if any other useful messages are printed by the kernel.

There is a period between this last message and the
console initialization, which can be quite long and the
"-p" option forces all messages to be printed via the
firmware.
