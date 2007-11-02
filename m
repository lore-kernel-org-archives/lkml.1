Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbXKBTah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbXKBTah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbXKBTa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:30:26 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:47947 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754693AbXKBTaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:30:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iJRO7SNb8zLEjZNQ9bxLpU9iqbX2ssrnHS8hnvVFk3p45Ql5N0ockzHYCVEn0GiuRdwlSux+8UGdadwFrFJCtn0JxrVhbTsyYm8rWhGHtHW96vINZQHP3UkuLVSE5jcFD4ET3jiM39bpmFiNHoY2rkE7zXpKnuW0mvVpxRsuq9U=  ;
X-YMail-OSG: ZsFbFQkVM1lPyOxyakd9RIUvG1O0C2jrMzXOwsndzhctZeZqJDkLKfv8O3me0q3.gyWtbeC47Q--
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function `usbnet_set_settings':
Date: Fri, 2 Nov 2007 12:30:22 -0700
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
References: <200711012024.57412.toralf.foerster@gmx.de> <200711021145.15542.david-b@pacbell.net> <20071102185751.GV30287@stusta.de>
In-Reply-To: <20071102185751.GV30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711021230.22588.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 November 2007, Adrian Bunk wrote:
> This approach has two disadvantages:
> - it's complicated

No more so than the problem itself.


> - the MII stuff is an implementation detail, and we shouldn't bother
>   the user with it (especially since we can do better)

That's a Kconfig policy that's not always followed.  In this
case, I was getting fed up with "select".  It so rarely does
what it needs to do, and I've started to think it'd be better
to just always avoid that fragility than battle it.

 
> If you want to keep the #ifdef's, what's the problem with the second 
> patch I proposed to fix this bug?

For one thing, I didn't see it until after I posted this one...
other than that, the basic approach could well be fine; I didn't
go through it in detail.

But on the other hand, it seems that only the ASIX code will work
right; the DM9601 and MCS7830 Kconfig is different/wrong.

- Dave


