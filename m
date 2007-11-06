Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbXKFGDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbXKFGDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXKFGDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:03:46 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:39227 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752143AbXKFGDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:03:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GUOxqQUfGeVRkpLm/j1jun5wj8Zj1n1LuaZ4N4pRKJbxGpNOHsLC9AK1IABUaL/S1a9rZ6YKAzl5hGW8L/v2gjsk3hOvyMQXKJ/zikRVVGtap/qMRF+PmmGX0uOwMWoOPh5ypJ6TmwRxKXI3gO7Vwz0MF6DTeSW4Xnmzpj4d1xc=  ;
X-YMail-OSG: yDkRTGAVM1ncEpzE3puxUmkwTD4iy.ADKsuHeN0o.0BneNz9jE4odI.4SIdu3csjkhj7aYm1KA--
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 3/4] Blackfin SPI driver:  move hard coded pin_req to board file
Date: Mon, 5 Nov 2007 22:03:42 -0800
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <1193971112-7744-1-git-send-email-bryan.wu@analog.com> <1193971112-7744-4-git-send-email-bryan.wu@analog.com>
In-Reply-To: <1193971112-7744-4-git-send-email-bryan.wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711052203.42855.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007, Bryan Wu wrote:
> --- a/include/asm-blackfin/bfin5xx_spi.h
> +++ b/include/asm-blackfin/bfin5xx_spi.h
> @@ -152,6 +152,7 @@
>  struct bfin5xx_spi_master {
>         u16 num_chipselect;
>         u8 enable_dma;
> +       u16 pin_req[4];
>  };
>  
>  /* spi_board_info.controller_data for SPI slave devices,

I take it there's a patch some where -- outside of this set
of four -- to initialize that new field so drivers will get
valid pin setup data?  (That name doesn't sound like it's
platform data, by the way.)

That's going to need to merge in sync with this patch, else
I'd think the resulting kernel won't run ...

- Dave
