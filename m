Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbYC1WSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbYC1WSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbYC1WSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:18:43 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:37231 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757284AbYC1WSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:18:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=E54W4PHp6FO+gmcZm3OOozypn8/7QccxZbQB+5OxBXuVqsCJx1BqFRyvwMQkmsn5ZpfiFtNN/3lKpGe68ilHm8yK5n+vdzuvuKx2OcIhuBnf1k4IBNrOVuywcQNQZGZ9E+4srBGm+UgwgjzsRYsNyXoU3ygkbv+rSrSS4Tb0yQU=  ;
X-YMail-OSG: qQYlBl0VM1kVtE1zuqrGyh9VDWMmnFoIsIfrQ4cZ.GzxhH5jN4EJOq3qO6O8ujYSYaOLpi23Fg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
Date: Fri, 28 Mar 2008 15:18:35 -0700
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       David Miller <davem@davemloft.net>
References: <20080327160700.GB828@suse.de> <200803281445.08025.david-b@pacbell.net> <20080328215913.GL32200@cs181133002.pp.htv.fi>
In-Reply-To: <20080328215913.GL32200@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281518.36139.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Adrian Bunk wrote:

> > > grep for CONFIG_SUN_MOSTEK_RTC and you'll get the point.
> > 
> > Right:  it doesn't mention JS_RTC at all.  Whatever is up
> > with that stuff, it's broken.
> 
> You miss the point, the point is:
>   drivers/sbus/char/Makefile:obj-$(CONFIG_SUN_MOSTEK_RTC) += rtc.o
> 
> Two modules with the same name in one build are not allowed.

It gets uglier and uglier.  So if that abortion is really
needed, it'd make more sense to rename the MOSTEK code.
If that's not fixed, its Kconfig should mention needing
the JS_RTC thing instead of the "real" legacy rtc.c ...

Glad I got rid of my JavaStation ages ago, but I liked
the idea of having a real builtin coffee cup holder.  :)


You see why nobody wants to touch the legacy RTC stuff?
Some of it is broken *BY DESIGN* instead of just by
pure happenstance of evolution.

- Dave
