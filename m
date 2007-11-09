Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbXKIEhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbXKIEhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 23:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760789AbXKIEg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 23:36:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762743AbXKIEg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 23:36:56 -0500
Date: Thu, 8 Nov 2007 20:36:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: [PATCH] Add the macro to test if "exactly_one_bit_set" to
 log2.h.
Message-Id: <20071108203640.340751ba.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711061135310.23545@localhost.localdomain>
References: <Pine.LNX.4.64.0711061135310.23545@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 6 Nov 2007 11:38:52 -0500 (EST) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> 
> While this macro is defined in terms of "is_power_of_2" and is
> therefore functionally equivalent, the visual semantics are sometimes
> more appropriate for what is actually being tested.
> 

This is gettig a bit anal, but I guess you're the is_power_of_2 maintainer.

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

And I'm the dont-code-in-cpp-when-you-could-code-in-C maintainer.
