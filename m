Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbZDWTZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbZDWTZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbZDWTZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:25:16 -0400
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:36381 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752751AbZDWTZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:25:13 -0400
X-Yahoo-Newman-Id: 8058.11446.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DLJ5fBojW0wishSIGt+vJVIUwpIXx7jd1aZf/DC1PSTwSXf0KaMuHHBpVxK5vdS1zgej7yGM0ujuR0/HgL5vWpR45bUTUiCNX1pcCZkT3Yzg46g8uZwvbWqHf6ZXBWXdUP56sv+7aubaiTJXLVHhgMHT2JZXPzzvNmpi1IT+fFA=  ;
X-YMail-OSG: 9Z4Tua0VM1muaXbj_9IumK4YVqT6VbcZ7O7uACTWG0yy75c.Ob.BZ7ImH49vTjBl9_J4ySfWfavjHByx4UEAd0DoPJbibfbDtP1BwlEmfpPj1rvJgkKxYMnyAtvJ5yBVYwEXHIPgMm8X88vAios4GWUJi9IpPJJfo7nkGR1NBv0pWatSGVluxadfWQUUMZu4aFdRg2nZ.X6QYf13OhkMhrCFZ2bI08rINmaIZWDJy4bqI7gdePdJs9p1K1XOYbdxhaDC0ayoQ97lxrFaGRB6v3NqGYJJCwroFmtrod1.keh4rWvPJL_ZpHBdhy392tIjbw0t4KsqYQfe3rcMXy9w8RCP
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Date: Thu, 23 Apr 2009 12:25:01 -0700
User-Agent: KMail/1.9.10
Cc: rtc-linux@googlegroups.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it> <200904231202.49465.david-b@pacbell.net> <20090423210900.17311407@i1501.lan.towertech.it>
In-Reply-To: <20090423210900.17311407@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904231225.01618.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Alessandro Zummo wrote:
> On Thu, 23 Apr 2009 12:02:48 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > >  as I stated in the email to Andrew.
> > > 
> > >  do you agree? :)  
> > 
> > If (rtc_update_irq() starts disabling them locally,
> > 	&& its interface stops requiring callers to do that)
> > then
> > 	it's fine;
> > 
> 
>  but why rtc_update_irq should disable the IRQs? I believe
>  it can work just fine with IRQs enabled.

The last patch I saw was just changing from "caller must
disable them" to "rtc_update_irq() disables them".

If you're talking about a different patch, please forward...



