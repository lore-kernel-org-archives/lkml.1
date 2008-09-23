Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYIWQoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYIWQoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYIWQnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:43:51 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43647 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYIWQnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:43:51 -0400
Date: Tue, 23 Sep 2008 17:43:38 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: Export the ROM enable/disable helpers and use them in mtd
Message-ID: <20080923164338.GA12167@shareable.org>
References: <20080923172510.37419440@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923172510.37419440@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>  EXPORT_SYMBOL(pci_map_rom);
>  EXPORT_SYMBOL(pci_unmap_rom);
> +EXPORT_SYMBOL_GPL(pci_enable_rom);
> +EXPORT_SYMBOL_GPL(pci_disable_rom);

It doesn't _sound_ like the sort of thing tied into the kernel enough
to deserve an EXPORT_SYMBOL_*GPL*.  Any particularly reason?

Cheers,
-- Jamie
