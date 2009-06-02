Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZFBOHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZFBOHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZFBOHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:07:32 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56609 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZFBOHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:07:32 -0400
Date: Tue, 2 Jun 2009 10:05:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix typo in asm-generic/gpio.h
In-Reply-To: <20090602224936.8fb94b29.yoichi_yuasa@tripeaks.co.jp>
Message-ID: <alpine.LFD.2.00.0906021005200.7519@localhost.localdomain>
References: <20090602224936.8fb94b29.yoichi_yuasa@tripeaks.co.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Yoichi Yuasa wrote:

> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
>
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index d6c379d..2a37611 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -53,7 +53,7 @@ struct module;
>   *	negative during registration, requests dynamic ID allocation.
>   * @ngpio: the number of GPIOs handled by this controller; the last GPIO
>   *	handled is (base + ngpio - 1).
> - * @can_sleep: flag must be set iff get()/set() methods sleep, as they
> + * @can_sleep: flag must be set if get()/set() methods sleep, as they
>   *	must while accessing GPIO expander chips over I2C or SPI
>   * @names: if set, must be an array of strings to use as alternative
>   *      names for the GPIOs in this chip. Any entry in the array

  was that really a typo, or was it meant to represent "if and only
if?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
