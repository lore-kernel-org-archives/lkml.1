Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYFPLRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYFPLRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYFPLRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:17:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57430 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbYFPLRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:17:25 -0400
Date: Mon, 16 Jun 2008 11:59:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
Message-ID: <20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
In-Reply-To: <1213609751.26255.673.camel@pmac.infradead.org>
References: <1213609751.26255.673.camel@pmac.infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 10:49:11 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> Converted with help from Jaswinder Singh
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> ---
>  drivers/char/Kconfig           |    7 +
>  drivers/char/ip2/fip_firm.h    | 2149 ----------------------------------------
>  drivers/char/ip2/ip2base.c     |    5 +-
>  drivers/char/ip2/ip2main.c     |   45 +-
>  firmware/Makefile              |    1 +
>  firmware/WHENCE                |   10 +
>  firmware/intelliport2.bin.ihex | 2147 +++++++++++++++++++++++++++++++++++++++
>  7 files changed, 2201 insertions(+), 2163 deletions(-)
>  delete mode 100644 drivers/char/ip2/fip_firm.h
>  create mode 100644 firmware/intelliport2.bin.ihex

Fine by me. I've not checked all the digits are correct but the rest of
the logic seems clean enough

Acked-by: Alan Cox <alan@redhat.com>
