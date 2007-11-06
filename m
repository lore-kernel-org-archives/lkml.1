Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbXKFSOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbXKFSOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbXKFSOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:14:24 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22638 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754178AbXKFSOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:14:23 -0500
Message-ID: <4730AE66.6030501@panasas.com>
Date: Tue, 06 Nov 2007 20:11:50 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, matthew@wil.cx
Subject: Re: [PATCH] Add the macro to test if "exactly_one_bit_set" to log2.h.
References: <Pine.LNX.4.64.0711061135310.23545@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0711061135310.23545@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Nov 2007 18:11:53.0409 (UTC) FILETIME=[825DA310:01C820A0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06 2007 at 18:38 +0200, "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> While this macro is defined in terms of "is_power_of_2" and is
> therefore functionally equivalent, the visual semantics are sometimes
> more appropriate for what is actually being tested.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index c8cf5e8..d0d324e 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -55,6 +55,12 @@ bool is_power_of_2(unsigned long n)
>  }
> 
>  /*
> + *  And for folks who want slightly different semantics ...
> + */
> +
> +#define exactly_one_bit_set is_power_of_2

at_most_one_bit_set No?
> +
> +/*
>   * round up to nearest power of two
>   */
>  static inline __attribute__((const))

Boaz
