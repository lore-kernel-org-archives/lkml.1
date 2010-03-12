Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab0CLO5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:57:55 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:42124 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab0CLO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:57:54 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKLjmUtbstod/2dsb2JhbACDDJdedKpykCYNgSWCX2oE
Date: Fri, 12 Mar 2010 15:57:51 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ross Biro <rossb@google.com>, David Hardeman <david@2gen.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Watchdog: How to get rid =?utf-8?Q?of_?=
	=?utf-8?B?d2FybmluZyDigJhlc2JfcGNpX3RibOKAmQ==?= defined but not
	used
Message-ID: <20100312145751.GO4017@infomag.iguana.be>
References: <1267254779.25446.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267254779.25446.10.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Various people pointed this warning but it is still not fixed :
> 
>  CC      drivers/watchdog/i6300esb.o
> drivers/watchdog/i6300esb.c:341: warning: ‘esb_pci_tbl’ defined but not used
> 
> Is any special reason to keep this warning.

>From the source code:
 /*
 * Data for PCI driver interface
 *
 * This data only exists for exporting the supported
 * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
 * register a pci_driver, because someone else might one day
 * want to register another driver on the same PCI id.
 */

I changed the code so that in the next linux release you want have this anymore.

Wim.

