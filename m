Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYC1Vp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYC1Vp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbYC1VpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:45:15 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:29939 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754921AbYC1VpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:45:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0ISouotvHmZXwWb9Ea/UZPkSCn1bR9xslCn8Hi/ppJFIdE8vwQG0W9zsd54wErvAY5s/5KqT/0oibJ8rLJMq7IwE/axpVmInN5LOVuxoBJbli1ro5dj77Jgbi5/4nozzML/jrAJNR2rG+Cn3w2hdI7GlzbfggBKXlFWqz53uJNw=  ;
X-YMail-OSG: HvJFYsYVM1kAzAiB.nyIppZRW7HJ1YtMzzwnMYsXdCby3oda__MK3zrA9VOHXa6bl7Y2GgMvvQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
Date: Fri, 28 Mar 2008 14:45:07 -0700
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com,
       David Miller <davem@davemloft.net>
References: <20080327160700.GB828@suse.de> <200803281423.46981.david-b@pacbell.net> <20080328213349.GK32200@cs181133002.pp.htv.fi>
In-Reply-To: <20080328213349.GK32200@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803281445.08025.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Adrian Bunk wrote:
> > > >   "JS_RTC" ... a SPARC32 thing
> > > >       --> bug?? no "js-rtc.c" in the tree!  patch sent
> > > 
> > > Where's the bug?
> > > js-rtc is built from rtc.c
> > 
> > In which case, just enable rtc.c ... a "egrep -r 'JS_RTC|js-rtc'"
> > shows that it looks pretty pointless.
> >...
> 
> grep for CONFIG_SUN_MOSTEK_RTC and you'll get the point.

Right:  it doesn't mention JS_RTC at all.  Whatever is up
with that stuff, it's broken.

