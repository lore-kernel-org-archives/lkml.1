Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYEGXWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYEGXWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbYEGXWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:22:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759629AbYEGXWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:22:18 -0400
Date: Wed, 7 May 2008 16:21:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Trivial] Update contact information
Message-Id: <20080507162143.cde04578.akpm@linux-foundation.org>
In-Reply-To: <1208945433.4298.12.camel@debian>
References: <1208945433.4298.12.camel@debian>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008 12:10:33 +0200
Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> 
> I have changed my email address as well as the drivers/auxdisplay webpage, so this patch updates the contact information.
> 
> PS: If anyone has emailed me last weeks at maxextreme@gmail.com, please send again your message, I may have lost it. Sorry for the inconvenience.
> 
> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> 
> ---
> diff -uprN linux-2.6.25-o/CREDITS linux-2.6.25/CREDITS
> --- linux-2.6.25-o/CREDITS	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25/CREDITS	2008-04-21 17:54:39.000000000 +0200
> @@ -2609,8 +2609,8 @@ S: Perth, Western Australia
>  S: Australia
>  
>  N: Miguel Ojeda Sandonis
> -E: maxextreme@gmail.com
> -W: http://maxextreme.googlepages.com/
> +E: miguel.ojeda.sandonis@gmail.com
> +W: http://jair.lab.fi.uva.es/~migojed/
>  D: Author of the ks0108, cfag12864b and cfag12864bfb auxiliary display drivers.
>  D: Maintainer of the auxiliary display drivers tree (drivers/auxdisplay/*)
>  S: C/ Mieses 20, 9-B
> diff -uprN linux-2.6.25-o/Documentation/auxdisplay/cfag12864b linux-2.6.25/Documentation/auxdisplay/cfag12864b
> --- linux-2.6.25-o/Documentation/auxdisplay/cfag12864b	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25/Documentation/auxdisplay/cfag12864b	2008-04-21 18:09:14.000000000 +0200
> @@ -2,9 +2,9 @@
>  	cfag12864b LCD Driver Documentation
>  	===================================
>  
> -License:		GPLv2
> -Author & Maintainer:	Miguel Ojeda Sandonis <maxextreme@gmail.com>
> -Date:			2006-10-27
> + License: GPLv2
> +  Author: Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
> +    Date: 2006-10-27
>  
>  
>  
> diff -uprN linux-2.6.25-o/Documentation/auxdisplay/cfag12864b-example.c linux-2.6.25/Documentation/auxdisplay/cfag12864b-example.c
> --- linux-2.6.25-o/Documentation/auxdisplay/cfag12864b-example.c	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.25/Documentation/auxdisplay/cfag12864b-example.c	2008-04-21 18:08:45.000000000 +0200
> @@ -4,7 +4,8 @@
>   * Description: cfag12864b LCD userspace example program
>   *     License: GPLv2
>   *
> - *      Author: Copyright (C) Miguel Ojeda Sandonis <maxextreme@gmail.com>
> + *      Author: Copyright (C) Miguel Ojeda Sandonis
> + *              <miguel.ojeda.sandonis@gmail.com>
>
> [etc]

 CREDITS                                       |    4 ++--
 Documentation/auxdisplay/cfag12864b           |    6 +++---
 Documentation/auxdisplay/cfag12864b-example.c |    3 ++-
 Documentation/auxdisplay/ks0108               |    6 +++---
 MAINTAINERS                                   |   16 ++++++++--------
 drivers/auxdisplay/cfag12864b.c               |    5 +++--
 drivers/auxdisplay/cfag12864bfb.c             |    5 +++--
 drivers/auxdisplay/ks0108.c                   |    5 +++--
 include/linux/cfag12864b.h                    |    3 ++-
 include/linux/ks0108.h                        |    3 ++-
 10 files changed, 31 insertions(+), 25 deletions(-)

The preferred approach here is to remove the email address from the various
.c and .h files altogether.  People can then look up "Miguel Ojeda
Sandonis" in ./MAINTAINERS and ./CREDITS to find you.  And next time you
move, we only need to alter those files.



