Return-Path: <linux-kernel-owner+w=401wt.eu-S2992809AbXCHA2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992809AbXCHA2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992810AbXCHA2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:28:13 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:47569 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992809AbXCHA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:28:12 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 7 Mar 2007 19:25:26 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Replace misspelled "PRINTK" with "CONFIG_PRINTK".
In-Reply-To: <20070308000858.GE31910@redhat.com>
Message-ID: <Pine.LNX.4.64.0703071925100.9922@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703071836420.3888@CPE00045a9c397f-CM001225dbafb6>
 <20070308000858.GE31910@redhat.com>
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

On Wed, 7 Mar 2007, Dave Jones wrote:

> On Wed, Mar 07, 2007 at 06:38:32PM -0500, Robert P. J. Day wrote:
>  >
>  >   Replace the apparently misspelled preprocessor variable "PRINTK"
>  > with "CONFIG_PRINTK".
>
> this looks wrong.
>
>  > diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>  > index 5554ada..0c09772 100644
>  > --- a/drivers/md/bitmap.c
>  > +++ b/drivers/md/bitmap.c
>  > @@ -53,7 +53,7 @@
>  >  //#define DPRINTK PRINTK /* set this NULL to avoid verbose debug output */
>  >  #define DPRINTK(x...) do { } while(0)
>  >
>  > -#ifndef PRINTK
>  > +#ifndef CONFIG_PRINTK
>  >  #  if DEBUG > 0
>  >  #    define PRINTK(x...) printk(KERN_DEBUG x)
>  >  #  else
>
> the intention here is to only define 'PRINTK' if no-one else
> has defined it already.

oops, sorry, i misread that.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
