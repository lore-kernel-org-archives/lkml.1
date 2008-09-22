Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbYIVCBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbYIVCBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 22:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYIVCBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 22:01:23 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:41390 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752685AbYIVCBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 22:01:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=usdm7UCjHKoySEG93Jr1c4ZUU3Dw8T3Y3oRju/ZfsQ07aQnNFLJ1Rw833PyPY0kGGEoD3KBTvlVj9+wzI/Kh4HTxQXiX17UMgs6p3taRHam+NTCgEAmD4p3F56GF3DUAXDgwnPp15ebk48DHxpqHr2zWuEWo7F5r5+tC8cOX7Jk=  ;
X-YMail-OSG: xKzJcl8VM1kuvR9rKx6mehxbZn2BfQYJynJzXfQjMP01.7BtsjtCPeNMmPaQqTUtOI_DPlr8LgJD7MiSOyXyxxP.SrjYvgd3X5rUkBHNp2VAosfjnVJB8UrW0M8AUPkqj4Os.irF2eXw9sOXCVhNPM1ostrogDnBUw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Date: Sun, 21 Sep 2008 19:01:18 -0700
User-Agent: KMail/1.9.9
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <20080920180018.GD9873@flint.arm.linux.org.uk> <20080921184058.GC7961@atomide.com>
In-Reply-To: <20080921184058.GC7961@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809211901.19080.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 September 2008, Tony Lindgren wrote:
> Hey, you gotta give Dave some credit! Dave's been polishing tons of omap
> code in addition to the USB, at least I2C, gpio, SPI come to mind. Not to
> mention all the blinking leds!

Blinky leds can be the first visible sign of progress!  ;)


> Regarding getting an army of people to fix code, we need to start
> following another standard policy: All drivers must have a MAINTAINER
> who is capable of fixing things, and ideally doing things the right
> way from the start.

Which includes pushing their code into mainline ... and getting
acks (as you noted elsewhere) from the subsystem maintainer to
help avoid going too far astray.

In some cases that implies getting some new frameworks into mainline,
or updating the ones that are there.  The ALSA-SOC stuff has been
a win there, in terms of maintainable code ... the previous solution
involved very little reuse of the funky codec and data stream code,
while now that's far more practical.

Similarly I2C driver model support, GPIO expander infrastructure,
and SPI:  instead of scattering board-specific code in drivers all
over the source tree, it can now be split out fairly cleanly.  That
makes maintainers much happier.

- Dave
