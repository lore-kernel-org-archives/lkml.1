Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXFPIcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXFPIcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 04:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbXFPIcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 04:32:13 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54678 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbXFPIcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 04:32:12 -0400
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>
In-Reply-To: <200706152322.07739.ak@suse.de>
References: <200706151355.57464.ak@suse.de> <200706151454.28854.ak@suse.de>
	 <200706151650.53481.rgetz@blackfin.uclinux.org>
	 <200706152322.07739.ak@suse.de>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 09:31:41 +0100
Message-Id: <1181982701.25228.615.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 23:22 +0200, Andi Kleen wrote:
> > For the architecture we use (Blackfin), it does not support unaligned
> > accesses, and we purposely never put in the trap/fixup code - we trap, and
> > printk("fix your source");
> 
> For the kernel you should fix up too in addition to the printk. Otherwise
> you risk a ping of death in the field with some more obscure protocol.
> Also the printk should be load limited.

Sometimes you can't. Some architectures don't even take a trap, and on
others (FR-V without MMU) it's an imprecise exception.

-- 
dwmw2

