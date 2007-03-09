Return-Path: <linux-kernel-owner+w=401wt.eu-S1767630AbXCIXMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767630AbXCIXMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767632AbXCIXMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:12:48 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:42498 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767627AbXCIXMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:12:37 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 9 Mar 2007 18:09:58 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Rusty Russell <rusty@rustcorp.com.au>
cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
In-Reply-To: <1173481052.32234.137.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703091808490.5714@CPE00045a9c397f-CM001225dbafb6>
References: <1173419792.32234.131.camel@localhost.localdomain>
 <1173481052.32234.137.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Rusty Russell wrote:

> On Fri, 2007-03-09 at 16:56 +1100, Rusty Russell wrote:
> > __builtin_types_compatible_p() has been around since gcc 2.95, and we
> > don't use it anywhere.  This patch quietly fixes that.
>
> OK, many people complained that it needed a comment.  Good point!
> ==
> Add comment to ARRAY_SIZE macro.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff -r 933e410f204f include/linux/kernel.h
> --- a/include/linux/kernel.h	Sat Mar 10 09:55:31 2007 +1100
> +++ b/include/linux/kernel.h	Sat Mar 10 09:55:53 2007 +1100
> @@ -35,6 +35,7 @@ extern const char linux_proc_banner[];
>  #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
>  #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
>
> +/* GCC is awesome. */
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
>  	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
>  		 typeof(&arr[0]))]))*0)

ah, but is that "universe" kind of awesome, or the "hot dogs" kind of
awesome?

http://youtube.com/watch?v=0rYT0YvQ3hs

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
