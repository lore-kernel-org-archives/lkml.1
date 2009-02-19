Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZBSTeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZBSTeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZBSTeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:34:08 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:28824 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752898AbZBSTeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:34:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u5lLGgMKZqqDJZ+4IJSw2MJNaQkhAs8LRoBcD+Gvuh9uXMiq9uV96TIxIp3SQmNIXwVKtn469NREcQ4buSFmRYogy2rT5LKiOmeufjVKR3LSZz0f8z1KmPRKkwfVm9yPop7tACkaDEZeNOhWEg7UiK4rIIdoMdn2GZ7alYzP6to=  ;
X-YMail-OSG: UGLQ29sVM1m2DhjnjahItlOBPyQZnWEAntqpHvW8psNQA34qhZZmhD_0TwEpmjxTO0myJ.2beyRtxitc.cr9tsc6AYEOXLvh_grdyAWHhjtLm7ZYXqo3.y5d6IgoyjLudD8sUKrkueTzsM_jZsy3L7W_vLx2Gjk9.swohSPBOpaP_W9pNB852H36ag--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] spi_bitbang: Add more lowlevel function documentation
Date: Thu, 19 Feb 2009 11:34:05 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200902191206.17734.mb@bu3sch.de>
In-Reply-To: <200902191206.17734.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191134.05173.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009, Michael Buesch wrote:
> This adds more documentation of the lowlevel API to avoid future bugs.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

... thanks.


> ---
> 
> Index: linux-2.6/include/linux/spi/spi_bitbang.h
> ===================================================================
> --- linux-2.6.orig/include/linux/spi/spi_bitbang.h	2009-02-19 11:59:23.000000000 +0100
> +++ linux-2.6/include/linux/spi/spi_bitbang.h	2009-02-19 12:04:09.000000000 +0100
> @@ -83,6 +83,13 @@ extern int spi_bitbang_stop(struct spi_b
>   *  int getmiso(struct spi_device *);
>   *  void spidelay(unsigned);
>   *
> + * setsck()'s is_on parameter is a zero/nonzero boolean.
> + *
> + * setmosi()'s is_on parameter is a zero/nonzero boolean.
> + *
> + * getmiso() is required to return 0 or 1 only. Any other value is invalid
> + * and will result in improper operation.
> + *
>   * A non-inlined routine would call bitbang_txrx_*() routines.  The
>   * main loop could easily compile down to a handful of instructions,
>   * especially if the delay is a NOP (to run at peak speed).
> 
> -- 
> Greetings, Michael.
> 
> 


