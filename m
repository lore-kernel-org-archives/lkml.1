Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbYCZK5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbYCZK5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYCZK5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:57:46 -0400
Received: from lazybastard.de ([212.112.238.170]:59064 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYCZK5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:57:45 -0400
Date: Wed, 26 Mar 2008 11:57:25 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch] bkl2mtd: cleanup
Message-ID: <20080326105724.GC22847@logfs.org>
References: <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326101452.GA17176@elte.hu> <20080326104821.GS10722@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080326104821.GS10722@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 March 2008 10:48:21 +0000, Al Viro wrote:
> 
> > -static int _block2mtd_write(struct block2mtd_dev *dev, const u_char *buf,
> > -		loff_t to, size_t len, size_t *retlen)
> > +static int
> > +_block2mtd_write(struct block2mtd_dev *dev, const u_char *buf, loff_t to,
> > +		 size_t len, size_t *retlen)
> 
> That's actually worse...  BTW, single-underscore-... for identifiers?  Odd.

Indeed.  Must have been my fault.

> OTOH, you've missed quite a few of my pet peeves, starting with
> u_char in the quoted part...

A large-scale s/u_char/void/ over mtd read and write functions wouldn't
hurt, no doubt.  Currently every other driver contains a cast to
(u_char*) or three for no gain afaics.

Jörn

-- 
Never argue with idiots - first they drag you down to their level,
then they beat you with experience.
-- unknown
