Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYC1O5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYC1O5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYC1O4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:56:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41998 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbYC1O4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:56:50 -0400
Date: Fri, 28 Mar 2008 15:56:49 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Brownell <david-b@pacbell.net>
cc: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
In-Reply-To: <200803280249.42193.david-b@pacbell.net>
Message-ID: <alpine.LNX.1.10.0803281555570.27567@fbirervta.pbzchgretzou.qr>
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu> <200803280249.42193.david-b@pacbell.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-03-28 10:49, David Brownell wrote:
> @@ -303,6 +299,7 @@ comment "Platform RTC drivers"
> config RTC_DRV_CMOS
> 	tristate "PC-style 'CMOS'"
> 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
> +	default y if X86
> 	help
> 	  Say "yes" here to get direct support for the real time clock
> 	  found in every PC or ACPI-based system, and some other boards.

I do not see why it should default to y, given that udev loads my m
perfectly fine.
