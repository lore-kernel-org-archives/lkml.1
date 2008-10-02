Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYJBMvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYJBMvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 08:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYJBMvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 08:51:35 -0400
Received: from khc.piap.pl ([195.187.100.11]:53659 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbYJBMve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 08:51:34 -0400
To: "Matti Linnanvuori" <mattilinn@gmail.com>
Cc: "Jeff Garzik" <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v0.7.67] WAN: add drivers etp and etp_stream
References: <ca0148c30810012305g182336b3k538bdd8e6d73953e@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 02 Oct 2008 14:51:31 +0200
In-Reply-To: <ca0148c30810012305g182336b3k538bdd8e6d73953e@mail.gmail.com> (Matti Linnanvuori's message of "Thu\, 2 Oct 2008 09\:05\:55 +0300")
Message-ID: <m33ajf40to.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Matti Linnanvuori" <mattilinn@gmail.com> writes:

> --- linux-2.6.27-rc2/drivers/net/wan/Makefile	2008-08-08
> 13:21:20.452131629 +0300
> +++ linux/drivers/net/wan/Makefile	2008-08-08 12:59:30.828005756 +0300
> @@ -41,6 +41,10 @@ obj-$(CONFIG_C101)		+= c101.o
>  obj-$(CONFIG_WANXL)		+= wanxl.o
>  obj-$(CONFIG_PCI200SYN)		+= pci200syn.o
>  obj-$(CONFIG_PC300TOO)		+= pc300too.o
> +etp-y				:= etp_main.o etp_idt.o etp_proc.o
> +obj-$(CONFIG_ETP)		+= etp.o syncppp.o

Syncppp is to be removed shortly, please use generic HDLC instead.
See the "next" branch for up-to-date details.
-- 
Krzysztof Halasa
