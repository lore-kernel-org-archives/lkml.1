Return-Path: <linux-kernel-owner+w=401wt.eu-S941579AbXHJTct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941579AbXHJTct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933577AbXHJTcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:32:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793AbXHJTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:32:40 -0400
Date: Fri, 10 Aug 2007 12:32:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Wim Van Sebroeck <wim@iguana.be>,
       "shannon.nelson@intel.com" <shannon.nelson@intel.com>
Subject: Re: Section mismatch warnings ( Re: 2.6.23-rc2-mm2 )
Message-Id: <20070810123215.904369e8.akpm@linux-foundation.org>
In-Reply-To: <46BCB6D5.1070506@googlemail.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC3CB1.2090503@googlemail.com>
	<46BC5C1D.50205@googlemail.com>
	<46BCB6D5.1070506@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 21:04:53 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> Some more
> 
> ...
> 
> WARNING: vmlinux.o(.text+0xce2ce): Section mismatch: reference to .init.data:lowhsync (between 'pm2fb_set_par' and 'pm2fb_pan_display')
> WARNING: vmlinux.o(.text+0xce2e8): Section mismatch: reference to .init.data:lowvsync (between 'pm2fb_set_par' and 'pm2fb_pan_display')
> WARNING: vmlinux.o(.text+0x180d3b): Section mismatch: reference to .init.data: (between 'iTCO_wdt_probe' and 'supermicro_new_unlock_watchdog')
> WARNING: vmlinux.o(.text+0x180e1d): Section mismatch: reference to .init.data: (between 'iTCO_wdt_probe' and 'supermicro_new_unlock_watchdog')
> WARNING: vmlinux.o(.text+0x180e25): Section mismatch: reference to .init.data:iTCO_chipset_info (between 'iTCO_wdt_probe' and 'supermicro_new_unlock_watchdog')
> WARNING: vmlinux.o(.data+0xa74f0): Section mismatch: reference to .init.text:ioat_probe (between 'ioat_pci_drv' and 'ioat_pci_tbl')
> 
> ...
> 
> http://194.231.229.228/kernel/mm/2.6.23-rc2-mm2/randconfig-auto-28

(suitable cc's added)
