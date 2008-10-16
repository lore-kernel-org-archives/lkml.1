Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYJPHaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYJPHaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYJPHaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:30:09 -0400
Received: from relay.heise.de ([193.99.145.50]:57982 "EHLO relay.heise.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbYJPHaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:30:08 -0400
X-Greylist: delayed 1672 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2008 03:30:07 EDT
Message-ID: <48F6E6EF.8020701@ct.heise.de>
Date: Thu, 16 Oct 2008 09:02:07 +0200
From: Thorsten Leemhuis <thl@ct.heise.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>
In-Reply-To: <20081016002509.GA25868@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.10.2008 02:25, Greg KH wrote:
> You brought this topic up a few months ago, and passed it off as
> something we would discuss at the kernel summit.  But that never
> happened, so I figured I'd bring it up again here.
> 
> So, as someone who constantly is dealing with kernel version numbers all
> the time with the -stable trees, our current numbering scheme is a pain
> a times.  How about this proposal instead?
> 
> We number the kernel based on the year, and the numbers of releases we
> have done this year:
> 	YEAR.NUMBER.MINOR_RELEASE
> 
> For example, the first release in 2009 would be called:
> 	2009.0.0
> The second:
> 	2009.1.0
> [...]

That afaics has one minor downside: You don't know in advance how the 
next kernel is going to be called. Example: the kernel that is currently 
developed could become 2008.4 (the fifth kernel in 2008) if this 
development cycle in the end is one of the quicker ones and gets 
finished this year. But if everything is a bit slower then it might 
become 2009.0 (the first one in 2009).

Hence people that write a lot of articles about things that happen in 
linux land (like LWN.net or I do) would be forced to write sentences 
like "[...]the kernel that will become 2008.3 or 2009.0 will have 
feature foo that works like this[...]". That will get really confusing 
if you read those articles half a year later -- especially if that 
kernel became 2008.3 in the end, because foo in 2009.0 might already 
look quite different again...

> [...] Let the bike-shedding begin!

Please paint a tux on top of the roof.

CU
thl
-- 
Thorsten Leemhuis
  c't- Magazin für Computertechnik       web    http://www.heise.de/ct/
  Heise Zeitschriften Verlag GmbH&Co.KG  phone  +49 (0)511 5352 300
  Helstorfer Str. 7                      icq    140593172
  D-30625 Hannover, Germany              jabber thl_at_work@jabber.ccc.de

/* Heise Zeitschriften Verlag GmbH & Co. KG, Registergericht:
    Amtsgericht Hannover HRA 26709; Persönlich haftende Gesellschafterin:
    Heise Zeitschriften Verlag Geschäftsführung GmbH, Registergericht:
    Amtsgericht Hannover, HRB 60405 Geschäftsführer: Ansgar Heise,
    Steven P. Steinkraus, Dr. Alfons Schräder                          */
