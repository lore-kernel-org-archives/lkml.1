Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbXJaJF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbXJaJF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbXJaJFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:05:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49241
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753598AbXJaJFo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:05:44 -0400
Date: Wed, 31 Oct 2007 02:05:43 -0700 (PDT)
Message-Id: <20071031.020543.193690729.davem@davemloft.net>
To: toralf.foerster@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: build #336 failed for 2.6.24-rc1-ga3634d7 in
 linux/.check.tipc_config.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710310952.53973.toralf.foerster@gmx.de>
References: <200710310952.53973.toralf.foerster@gmx.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toralf Förster <toralf.foerster@gmx.de>
Date: Wed, 31 Oct 2007 09:52:53 +0100

> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
>   CHECK   include/linux/times.h
>   CHECK   include/linux/tiocl.h
>   CHECK   include/linux/tipc.h
>   CHECK   include/linux/tipc_config.h
> /home/tfoerste/devel/linux-2.6/usr/include/linux/tipc_config.h requires linux/string.h, which does not exist in exported headers
> make[3]: *** [/home/tfoerste/devel/linux-2.6/usr/include/linux/.check.tipc_config.h] Error 1
> make[2]: *** [linux] Error 2
> make[1]: *** [headers_check] Error 2
> make: *** [vmlinux] Error 2

This has been reported several times and a fix has been submitted.
