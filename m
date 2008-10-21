Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYJUMk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYJUMk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYJUMko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:40:44 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53080 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbYJUMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YQe1kLYuKcOnnHK+4o8N1PiioPavB/V6YLbup69p3gViYS76ovRQF+L2Cn6Go5dDMQ
         c9Tm9AsO5j+thdGJGGsBVxUB+7dyHNqHQR7HDNu0WuqiKTykv7pS+qn3sPB/E3tRpYjE
         A9krv6b+RW2PXRUnKGIiE27FcImiezdwRhb6s=
Message-ID: <aec7e5c30810210540p6b50562ax50b0cdd9af9e12e7@mail.gmail.com>
Date: Tue, 21 Oct 2008 21:40:41 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch 2.6.27-git] spi_gpio driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200810192124.36402.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807202146.12759.mb@bu3sch.de>
	 <200810181354.23955.david-b@pacbell.net>
	 <aec7e5c30810191944u4c125943h895099b3f1eaa813@mail.gmail.com>
	 <200810192124.36402.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 1:24 PM, David Brownell <david-b@pacbell.net> wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
>
> Generalize the old at91rm9200 "bootstrap" bitbanging SPI master driver
> as "spi_gpio", so it works with arbitrary GPIOs and can be configured
> through platform_data.  Such SPI masters support:
>
>  - any number of bus instances (bus_num is the platform_device.id)
>  - any number of chipselects (one GPIO per spi_device)
>  - all four SPI_MODE values, and SPI_CS_HIGH
>  - i/o word sizes from 1 to 32 bits;
>  - devices configured as with any other spi_master controller
>
> When configured using platform_data, this provides relatively low clock
> rates.  On platforms that support inlined GPIO calls, significantly
> improved transfer speeds are also possible with a semi-custom driver.
> (It's still painful when accessing flash memory, but less so.)
>
> Sanity checked by using this version to replace both native controllers
> on a board with six different SPI slaves, relying on three different
> SPI_MODE_* values and both SPI_CS_HIGH settings for correct operation.
>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Works fine on SuperH together with the mmc_spi driver. Thanks!

Acked-by: Magnus Damm <damm@igel.co.jp>
