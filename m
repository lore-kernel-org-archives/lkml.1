Return-Path: <linux-kernel-owner+w=401wt.eu-S2992792AbXCHAJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992792AbXCHAJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992794AbXCHAJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:09:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992792AbXCHAJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:09:27 -0500
Date: Wed, 7 Mar 2007 19:08:58 -0500
From: Dave Jones <davej@redhat.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Replace misspelled "PRINTK" with "CONFIG_PRINTK".
Message-ID: <20070308000858.GE31910@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
References: <Pine.LNX.4.64.0703071836420.3888@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703071836420.3888@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 06:38:32PM -0500, Robert P. J. Day wrote:
 > 
 >   Replace the apparently misspelled preprocessor variable "PRINTK"
 > with "CONFIG_PRINTK".

this looks wrong.
 
 > diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
 > index 5554ada..0c09772 100644
 > --- a/drivers/md/bitmap.c
 > +++ b/drivers/md/bitmap.c
 > @@ -53,7 +53,7 @@
 >  //#define DPRINTK PRINTK /* set this NULL to avoid verbose debug output */
 >  #define DPRINTK(x...) do { } while(0)
 > 
 > -#ifndef PRINTK
 > +#ifndef CONFIG_PRINTK
 >  #  if DEBUG > 0
 >  #    define PRINTK(x...) printk(KERN_DEBUG x)
 >  #  else

the intention here is to only define 'PRINTK' if no-one else
has defined it already.

	Dave

-- 
http://www.codemonkey.org.uk
