Return-Path: <linux-kernel-owner+w=401wt.eu-S1030356AbXFHQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030356AbXFHQjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763733AbXFHQjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:39:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57268 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968544AbXFHQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:39:04 -0400
Date: Fri, 8 Jun 2007 18:39:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>, jcm@jonmasters.org,
       Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070608163911.GA3569@stusta.de>
References: <20070607232248.332edee8@the-village.bc.nu> <20070607232152.GU5500@stusta.de> <20070608004117.57868755@the-village.bc.nu> <20070608000455.GW5500@stusta.de> <20070608115219.694c642d@the-village.bc.nu> <20070608123942.GZ5500@stusta.de> <9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com> <20070608144230.GA5500@stusta.de> <Pine.LNX.4.64.0706081710380.10769@fbirervta.pbzchgretzou.qr> <20070608164236.4ba7acae@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070608164236.4ba7acae@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 04:42:36PM +0100, Alan Cox wrote:
> > >>> Does the console handle it correctly during boot?
> 
> Yes
> 
> > >>> Can all tools that process the syslog cope with it?
> 
> Thats a stupid question. The tools people normally use can just fine.
> 
> > >If you find any source file that contains UTF-8 outside of comments 
> > >please complain loudly.
> > 
> > I present loudly and proudly (I *don't* complain):
> 
> Point made - Adrian, if the tool complains about UTF-8 in author texts
> then its buggy and should not be merged. The fact you have a personal
> issue with it is neither here nor there

It's not a personal issue. Generally, I like UTF-8.

I'm simply saying that allowing UTF-8 in MODULE_AUTHOR and printk's as 
you want to can have unwanted effects.

And I gave modinfo as an example for a tool that is not yet able to 
handle UTF-8 correctly in all cases.

In my opinion, it's not worth the hassle to allow UTF-8 there.
Feel free to disagree.

> > So, we had some ISO8859-1 and some UTF-8 in there already. (And as for 
> > MODULE_AUTHOR, it should stay there - 'fix' modinfo instead.)
> 
> Using UTF-8 not 8859-1 for consistency is sensible, especially as 8859-1
> is obsolete and effectively useless now (although I guess much of the
> '8859-1' in the kernel is 1:1 with 8859-15, which isn't so obsolete but
> is just as useless)

Agreed, if we allow a non-ASCII charset, it should be UTF-8.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

