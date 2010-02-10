Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0BJG5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 01:57:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0BJG5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 01:57:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2 -mm 01/14] adds include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 07:57:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, James Bottomley <James.Bottomley@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Zankel <chris@zankel.net>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1265765687-14121-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1265765687-14121-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002100757.28712.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/N5XlecRyn27jilJmNK6fL5VdX2tCoBJ8ErOZ
 J8hyDEXYyB4ACMaBkPcGT8NwM0WjYru1cZsBh0oEIP3WTmt6Yf
 X6bYW4Ez9M99W2om2yuOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010, FUJITA Tomonori wrote:
> This patch adds include/linux/pci-dma.h that defines the pci_unmap
> state API:
> 
> DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
> DECLARE_PCI_UNMAP_LEN(LEN_NAME)
> pci_unmap_addr(PTR, ADDR_NAME)
> pci_unmap_addr_set(PTR, ADDR_NAME, VAL)
> pci_unmap_len(PTR, LEN_NAME)
> pci_unmap_len_set(PTR, LEN_NAME, VAL)
> ...
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Arnd Bergmann <arnd@arndb.de>
