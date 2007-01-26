Return-Path: <linux-kernel-owner+w=401wt.eu-S1030625AbXAZCWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030625AbXAZCWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030710AbXAZCWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:22:39 -0500
Received: from customer-domains.icp-qv1-irony15.iinet.net.au ([203.59.1.175]:60532
	"EHLO customer-domains.icp-qv1-irony15.iinet.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030625AbXAZCWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:22:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAA71uEXKoR9jdGdsb2JhbACOAQ
X-IronPort-AV: i="4.13,240,1167580800"; 
   d="scan'208"; a="34946030:sNHT7891590"
Message-ID: <45B965EA.20106@eyal.emu.id.au>
Date: Fri, 26 Jan 2007 13:22:34 +1100
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Organization: Eyal at Home
User-Agent: Debian Thunderbird 1.0.2 (X11/20061113)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - build failure
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <45B89008.9000809@eyal.emu.id.au>
In-Reply-To: <45B89008.9000809@eyal.emu.id.au>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I should have added that this is on Debian stable:
	$ gcc --version
	gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)

Eyal Lebedinsky wrote:
> i386
> Practically all modules selected.
> 
>   Building modules, stage 2.
>   MODPOST 1931 modules
> WARNING: drivers/atm/fore_200e.o - Section mismatch: reference to .init.text: from .text between 'fore200e_initialize' (at offset 0x25af) and 'fore200e_monitor_putc'
> WARNING: drivers/atm/lanai.o - Section mismatch: reference to .init.text: from .text between 'sram_test_pass' (at offset 0x1a8) and 'sram_test_and_clear'
> WARNING: drivers/atm/zatm.o - Section mismatch: reference to .init.text: from .text after 'zatm_init_one' (at offset 0x1f25)
> WARNING: drivers/atm/zatm.o - Section mismatch: reference to .init.text: from .text after 'zatm_init_one' (at offset 0x1f32)
> WARNING: drivers/net/rrunner.o - Section mismatch: reference to .init.text:rr_init from .text between 'rr_init_one' (at offset 0x1d0) and 'rr_remove_one'
> WARNING: drivers/net/sis900.o - Section mismatch: reference to .init.text:sis900_mii_probe from .text between 'sis900_probe' (at offset 0x47b) and 'sis900_default_phy'
> WARNING: drivers/net/sunhme.o - Section mismatch: reference to .init.text: from .text between 'happy_meal_pci_probe' (at offset 0x2add) and 'happy_meal_pci_remove'
> WARNING: drivers/net/tokenring/3c359.o - Section mismatch: reference to .init.text:xl_init from .text between 'xl_probe' (at offset 0x1da) and 'xl_hw_reset'
> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to .init.text: from .text between 'de_init_one' (at offset 0x2151) and 'de_remove_one'
> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to .init.text: from .text between 'de_init_one' (at offset 0x2158) and 'de_remove_one'
> WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to .init.text: from .text between 'de_init_one' (at offset 0x2220) and 'de_remove_one'
> WARNING: "__udivdi3" [fs/ocfs2/ocfs2.ko] undefined!
> make[1]: *** [__modpost] Error 1

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
