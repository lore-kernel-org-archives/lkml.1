Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbYHHRtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbYHHRtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbYHHRt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:49:29 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:8964 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758097AbYHHRt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:49:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkFAEkjnEhR8DtG/2dsb2JhbACBXKsx
Date: Fri, 8 Aug 2008 19:49:25 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: Fix build with CONFIG_ITCO_VENDOR_SUPPORT=n
Message-ID: <20080808174925.GC2773@infomag.infomag.iguana.be>
References: <20080808102921.3ec92c4f@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808102921.3ec92c4f@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> The problem is that iTCO_vendor_support.ko is still being built while
> iTCO_vendor.h claims that its functions do not exist. The following
> Makefile update fixes that. It causes iTCO_vendor_support.ko to no
> longer be built if CONFIG_ITCO_VENDOR_SUPPORT=n.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>

Will be added for the next release to Linus.

For all other developers, this is what is still in the queue:
* Fix iTCO_vendor_support
* MAINTAINERS: remove ZF MACHZ WATCHDOG entry
* watchdog: delete unused driver mpc8xx_wdt.c
* ALi M7101 PMU also available on Sun Netra's too
* Add AT91SAM9/CAP9 watchdog driver
* the s3c2410 watchdog fixes that have not been merged yet (if still any).
* Add kdebug support for for hpwdt
* Add watchdog driver IT8716 IT8726 IT8712J/K
* Add Orion hardware watchdog support
* Add PNX833x WDT Support
* Add RC32434 watchdog
* Add support for the built-in RDC R-321x SoC watchdog
* Add driver for winbond w83697ug/uf watchdog feature

Kind regards,
Wim.

