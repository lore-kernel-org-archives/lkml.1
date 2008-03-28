Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbYC1VYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbYC1VYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYC1VX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:23:57 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:21527 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756574AbYC1VX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:23:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=W1xVVDvf5igrqr9xA2iVoMGhpl/Ju08vWZ4BBaVwbnrd5cZR3jLuUHzVooXTWpCOFmA9d7Z0IiXUyfEnoQQ+CWniBlGjmRdv6SEAlLtZQ5dOTumT70HlG2ylTxVgNwtkMSLXcF5X4ybIIya7u/bnKoaq+GaOCcOxxxh8wQGqNNM=  ;
X-YMail-OSG: cwV3xB0VM1mYWp3v6gB3IPnp1NbvGJKSBPnMaRJfLPhHWVB4NjH2a9CgiK7raMVuYWmLH.9Ypg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
Date: Fri, 28 Mar 2008 14:23:45 -0700
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, David Miller <davem@davemloft.net>
References: <20080327160700.GB828@suse.de> <200803281304.39022.david-b@pacbell.net> <20080328210643.GJ32200@cs181133002.pp.htv.fi>
In-Reply-To: <20080328210643.GJ32200@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803281423.46981.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Adrian Bunk wrote:
> >   "JS_RTC" ... a SPARC32 thing
> >       --> bug?? no "js-rtc.c" in the tree!  patch sent
> 
> Where's the bug?
> js-rtc is built from rtc.c

In which case, just enable rtc.c ... a "egrep -r 'JS_RTC|js-rtc'"
shows that it looks pretty pointless.


> >...
> >   "DS1302" ... M32R-specific, "rtc-ds1302" should replace it
> >       --> ready to deprecate now?
> >...
> 
> Kconfig currently offers rtc-ds1302 only for an sh platform...

Right, I looked at that a bit more.  The rtc-ds1302 code was
not written portably.   If it were updated to get addresses
from platform resources -- like *normal* platform drivers do,
since the addresses are platform specific -- and if those two
M32R platforms got updated ... *then* this could be deprecated.

- Dave



