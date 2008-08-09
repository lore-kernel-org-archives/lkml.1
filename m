Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYHIWF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYHIWF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYHIWFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:05:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34441 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYHIWFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:05:07 -0400
Date: Sat, 9 Aug 2008 15:04:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: build issue #552 for v2.6.27-rc2-325-g796aade
 :drivers/watchdog/pcwd.c : incompatible pointer type
Message-Id: <20080809150410.513c41ef.randy.dunlap@oracle.com>
In-Reply-To: <200808092154.11834.toralf.foerster@gmx.de>
References: <200808092154.11834.toralf.foerster@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2008 21:54:05 +0200 Toralf Förster wrote:

> Hello,
> 
> the build (.config attached) failed, make ends with :
> ...
>   CC      drivers/w1/slaves/w1_ds2433.o
>   CC      drivers/w1/slaves/w1_ds2760.o
>   LD      drivers/w1/slaves/built-in.o
>   LD      drivers/w1/built-in.o
>   CC      drivers/watchdog/pcwd.o
> drivers/watchdog/pcwd.c: In function 'pcwd_open':
> drivers/watchdog/pcwd.c:703: warning: passing argument 2 of 'test_and_set_bit' from incompatible pointer type
> drivers/watchdog/pcwd.c: In function 'pcwd_close':
> drivers/watchdog/pcwd.c:723: warning: passing argument 2 of 'clear_bit' from incompatible pointer type
>   CC      drivers/watchdog/mixcomwd.o
>   CC      drivers/watchdog/pcwd_pci.o
>   CC      drivers/watchdog/wdt_pci.o
>   CC      drivers/watchdog/acquirewdt.o
>   CC      drivers/watchdog/advantechwdt.o
>   CC      drivers/watchdog/alim7101_wdt.o
> drivers/watchdog/alim7101_wdt.c:424: warning: 'alim7101_pci_tbl' defined but not used
>   CC      drivers/watchdog/ibmasr.o
>   CC      drivers/watchdog/iTCO_wdt.o
>   CC      drivers/watchdog/iTCO_vendor_support.o
> drivers/watchdog/iTCO_vendor_support.c:247: error: expected identifier or '(' before '{' token
> drivers/watchdog/iTCO_vendor_support.c:249: error: expected identifier or '(' before '{' token
> drivers/watchdog/iTCO_vendor_support.c:257: error: expected identifier or '(' before '{' token
> drivers/watchdog/iTCO_vendor_support.c:258: error: expected identifier or '(' before '{' token
> drivers/watchdog/iTCO_vendor_support.c:266: error: expected identifier or '(' before '{' token
> drivers/watchdog/iTCO_vendor_support.c:267: error: expected identifier or '(' before '{' token
> drivers/watchdog/iTCO_vendor_support.c:275: error: expected identifier or '(' before '{' token
> drivers/watchdog/iTCO_vendor_support.c:276: error: expected identifier or '(' before '{' token
> drivers/watchdog/iTCO_vendor_support.c:282:39: error: macro "iTCO_vendor_check_noreboot_on" passed 1 arguments, but takes just 0
> drivers/watchdog/iTCO_vendor_support.c:283: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
> make[2]: *** [drivers/watchdog/iTCO_vendor_support.o] Error 1
> make[1]: *** [drivers/watchdog] Error 2
> make: *** [drivers] Error 2
> 
> The build was made with :
> $>make randconfig; make clean; make
> 
> Here's the config:

Looks the same as reported on 8/8 with patch:
http://marc.info/?l=linux-kernel&m=121818422630481&w=2

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
