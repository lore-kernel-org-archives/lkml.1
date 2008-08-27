Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYH0KlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYH0KlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYH0KlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:41:00 -0400
Received: from ryu.zarb.org ([212.85.153.228]:38021 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbYH0KlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:41:00 -0400
Subject: Re: r8169 regression in 2.6.26.3 vs 2.6.26.2
From: Pascal Terjan <pterjan@mandriva.com>
To: Marcus Sundberg <marcus@ingate.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Francois Romieu <romieu@fr.zoreil.com>
In-Reply-To: <48B52E8C.40605@ingate.com>
References: <1219828800.30098.7.camel@plop>  <48B52E8C.40605@ingate.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Mandriva
Date: Wed, 27 Aug 2008 12:40:55 +0200
Message-Id: <1219833655.30098.9.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.90-1mdv2009.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 août 2008 à 12:38 +0200, Marcus Sundberg a écrit :
> Pascal Terjan wrote:
> > Since updating to 2.6.26.3, networking no longer works on Acer Aspire
> > One.
> > 
> > PCI config is now always filled with ones.
> > 
> > Reverting "r8169: avoid thrashing PCI conf space above
> > RTL_GIGA_MAC_VER_06" makes it work again.
> > 
> > The device is 10ec:8136
> 
> Ok, that's obviously not good. I checked the Realtek driver for
> 8101E (version r8101-1.009.00) and while it doesn't do any
> 8-bit writes to register 0x82 it does perform 32-bit writes to
> register 0x80 (EPHYAR) to communicate with the PHY. I have no
> idea what that 8-bit write does except it breaks the chipset in
> my LG P300...
> 
> How does the kernel identify your chipset upon driver load?
> (grep for XID)

eth0: RTL8169 at 0xe04ee000, 00:1e:68:a0:07:b5, XID 24a00000 IRQ 17


