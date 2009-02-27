Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbZB0Uk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbZB0Uk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759088AbZB0UkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:40:09 -0500
Received: from n8b.bullet.sp1.yahoo.com ([69.147.64.169]:42595 "HELO
	n8b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758427AbZB0UkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:40:08 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Id: 460771.33200.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0KjFuWT4v/72sQnmMqDaLLLH/PLMmPIGWsu9ggCTMtY+k7mexMh6x6LnlcsILqD88dAGI9dVyQpEmYqBi08xrK3OSAXDcxdFxbKz4KBjNLJscrFm9LY+UDXeaZR4Eo2fqyit+LX+iXhwHql+axBh2dNyHMWjH77Q3NK/a2mRVF0=  ;
X-YMail-OSG: 8BDLQ3kVM1mOdoo_KKwF60KstcfPgDyZynmL5AFOmiUY81SVaHThM7drxbqmXB1F0p7Mfws4eIs1uP8Wk578cu9FXeAugsnpEdsYnrMLCXucrfZsCs7uGjLfTMOI8GzKUSzzPyXnuxYtdBZx_LfKQNDdQO3zlTNpfLK.Uyb3rA2p1jDvQhbg.fdqyQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 2/2] regulator: twl4030 voltage enumeration (v2)
Date: Fri, 27 Feb 2009 12:39:44 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902261602.58832.david-b@pacbell.net> <1235737930.31223.117.camel@vega.slimlogic.co.uk>
In-Reply-To: <1235737930.31223.117.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902271239.44558.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Liam Girdwood wrote:
> On Thu, 2009-02-26 at 16:02 -0800, David Brownell wrote:
> > On Thursday 26 February 2009, Liam Girdwood wrote:
> > > > 
> > > > Note that the twl4030 regulator patch referred to will need a
> > > > minor patch to work with the -next tree, because of interface
> > > > change in the regulator framework.
> > > 
> > > Applied.
> > 
> > .... and here's that "minor patch".
> > 
> > ...
> 
> Sorry, this didn't apply. It looks like I'm missing an earlier patch(s)
> here. Could you regenerate this and your core patch against latest
> for-next.

The regulator -next tree seems to be missing a bunch of stuff...
I generated this patch against a "twl4030-regulator.c" which I
extracted *from that tree* yesterday.  But today it's different.

In this case, the current code doesn't have the $SUBJECT patch,
which at that time you had applied.  But it does have a small
snippet from that "minor patch"...


Color me confused.  Are you asking for a "v3" of $SUBJECT, or
is the "v2" going to re-appear?  And when will that -next tree
acquire the rest of

 http://marc.info/?l=linux-kernel&m=123567791402469&w=2

Having only the driver.h part of that patch breaks things
(your 0ae0e667c8a2bacfe066b90f8f2ee3b4a83a120d).

- Dave


