Return-Path: <linux-kernel-owner+w=401wt.eu-S965171AbXA3M0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171AbXA3M0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965290AbXA3M0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:26:11 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:44055 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965171AbXA3M0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:26:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=hZlFGP9BS0rKVhTlN4CvE710ThdRYmfiq5o4yaHyYl372SXA64xTzKiA16E2bxCk9QCxzWo4v/j5Uf+yJ8X9QLAQpqh5iiAJ0icMIXTeFhlswWb8LOJYNSlcgLhuvr6D09L5e5Ta01/j27JbWZZncUD6GkNk+9900qDHb95O54E=  ;
X-YMail-OSG: i765lqMVM1maLrOe4sqK3tq3L4R5et4Qx08w285tXWhX4e0TGK3t49iMAzxl_S9YInhC2EQbysK4.dMV4VD8IIyCgfV0vsdNDk_HJkzVp2eQ06H2SAtFOeAcAApNedYR7yydktmwH4yk2cSo63sqRBSWB9TbTRr6
Message-ID: <45BF3954.8050106@yahoo.com.au>
Date: Tue, 30 Jan 2007 23:25:56 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   Add the inline function "is_power_of_2()" to log2.h, where the value
> zero is *not* considered to be a power of two.

> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
>  /*
> + *  Determine whether some value is a power of two, where zero is
> + * *not* considered a power of two.
> + */

Why the qualifier? Zero *is* not a power of 2, is it?

> +
> +static inline __attribute__((const))
> +bool is_power_of_2(unsigned long n)
> +{
> +	return (n != 0 && ((n & (n - 1)) == 0));
> +}
> +
> +/*
>   * round up to nearest power of two
>   */
>  static inline __attribute__((const))


-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
