Return-Path: <linux-kernel-owner+w=401wt.eu-S1762134AbXIMGm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762134AbXIMGm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 02:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXIMGmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 02:42:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46384 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbXIMGmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 02:42:51 -0400
Message-ID: <46E8DBE3.7040204@garzik.org>
Date: Thu, 13 Sep 2007 02:42:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kees Cook <kees@ubuntu.com>, linux-kernel@vger.kernel.org,
       Ben Collins <bcollins@ubuntu.com>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] pci: fix unterminated pci_device_id lists
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org>	 <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>	 <20070912215356.GC23294@kroah.com>	 <20070912160827.e359a53b.akpm@linux-foundation.org> <b6fcc0a0709122334qa31fffby4afbf857c92efb89@mail.gmail.com>
In-Reply-To: <b6fcc0a0709122334qa31fffby4afbf857c92efb89@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> -static struct pci_device_id rtl8139_pci_tbl[] = {
> +PCI_MODULE_DEVICE_TABLE_BEGIN(rtl8139_pci_tbl)
>  	{0x10ec, 0x8139, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
>  	{0x10ec, 0x8138, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
>  	{0x1113, 0x1211, PCI_ANY_ID, PCI_ANY_ID, 0, 0, RTL8139 },
> @@ -273,10 +273,7 @@ static struct pci_device_id rtl8139_pci_tbl[] = {
>  	{PCI_ANY_ID, 0x8139, 0x10ec, 0x8139, 0, 0, RTL8139 },
>  	{PCI_ANY_ID, 0x8139, 0x1186, 0x1300, 0, 0, RTL8139 },
>  	{PCI_ANY_ID, 0x8139, 0x13d1, 0xab06, 0, 0, RTL8139 },
> -
> -	{0,}
> -};
> -MODULE_DEVICE_TABLE (pci, rtl8139_pci_tbl);
> +PCI_MODULE_DEVICE_TABLE_END


I think the previous version looks better.

	Jeff


