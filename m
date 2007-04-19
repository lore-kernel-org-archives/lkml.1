Return-Path: <linux-kernel-owner+w=401wt.eu-S2993229AbXDSLcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993229AbXDSLcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031221AbXDSLcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:32:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6370 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031207AbXDSLcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rlo4s7XsXlrl+V0rxYFtpAr2zl3AHM+KEbTJZQ0+hYK9u6WsVdTKRmgAh5HSFiY2q1Zb9tsoF/gg5Tb+QzZj7PQXVjTcCybzTqdVx5A2kJq0IfbzDkh3k0306+1zbD/Y4Bn9vTPb5AKtc8PhpH8xwzztz2tHgEVF0MUIw2Ab70A=
Subject: Re: How to structure an SPI UART driver?
From: dmitry pervushin <dpervushin@gmail.com>
Reply-To: dpervushin@gmail.com
To: Zik Saleeba <zik@zikzak.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <33e9dd1c0704190045v62cd1b4fm8ded434086108dd5@mail.gmail.com>
References: <33e9dd1c0704190045v62cd1b4fm8ded434086108dd5@mail.gmail.com>
Content-Type: text/plain; charset=KOI8-R
Date: Thu, 19 Apr 2007 15:33:11 +0400
Message-Id: <1176982391.4906.4.camel@diimka.dev.rtsoft.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Чтв, 2007-04-19 at 17:45 +1000, Zik Saleeba wrote:
> I'm looking for a little advice on writing a driver for the Phillips
> sc16is752 SPI UART chip. I've written drivers before but I'm having a
> problem with this one. Since this driver is both an SPI driver and a
> UART driver I'm unclear on whether it should register with
> spi_register_driver() or uart_register_driver(), or both, or do
> something completely different. I'm not clear on how to play nicely
> with both subsystems.
It should call both. Think about your driver as the middleware -- bottom
half is SPI driver (and uses spi_xxx calls to interact with hardware),
and upper half is UART (and uses uart_xxx calls to provide inerface). 
> Any hints?
...and welcome to spi-devel mailing list, spi-devel-general@lists.sourceforge.net
> Cheers,
> Zik
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml

