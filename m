Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbYD2WKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbYD2WKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbYD2WKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:10:19 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:38777 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755505AbYD2WKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:10:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KbpqT3qHBBz0mTOr9jVUHsws6T8P/QWFM24WAQYPJIkxKqSwynIuYVjK9PSlYvydoUTpwR+i8KKws0yWdqvord+62AYTd7ly+S8eBymi7r/F6XXCaN8DkTrlui1366DjS5Bl20KTrhClEq24KJ6GUTas6Jox4NCck6ZmgrSeN1k=  ;
X-YMail-OSG: XkAbNmgVM1mqd5eoayA9yCGoFqK_GxG7JduSrbDFeAoiGRBGkHiiYw0UsihBvHsHy2y2HDPnadtMrTPr3zIntxHiYt3YKsKFKn9HBlMj8yMNCxLUj1fDyaK17A_bBligX0Q-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Tue, 29 Apr 2008 14:28:58 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804281239.51729.david-b@pacbell.net> <200804282044.00706.david-b@pacbell.net> <1209444464.311.25.camel@moss.renham>
In-Reply-To: <1209444464.311.25.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804291428.59329.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Ben Nizette wrote:
> > > > 
> > > > Sysfs attributes are supposed to be pollable.  I've not done it,
> > > > but fs/sysfs/file.c::sysfs_notify() looks relevant ...
> > > 
> > > Right, that'll work.
> > 
> > OK.  In that case, I think I should plan to rename the "direction"
> > attribute as "configuration" or something a bit broader ... so that
> > writing "irq" (or maybe "rising", "falling", "bothedges", "poll")
> > would eventually configure it as an input with an IRQ handler.
> 
> Good plan, unless you'd prefer to see "direction" and "interrupt" config
> separate.  I have no real preference but IMO
>   echo "falling" > interrupt
> makes more immediate sense than
>   echo "falling" > configuration

OK, I'll leave it be then.  Given that not all GPIOs support
interrupts, I used the "poll" example intentionally ... being
able to poll every N seconds (milliseconds?) may be important.


> > 
> > Whenever someone contributes such an async notification scheme,
> > that is.  ;)
> 
> ;)


