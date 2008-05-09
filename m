Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYEIU3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYEIU3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYEIU30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:29:26 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61942 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753321AbYEIU3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:29:25 -0400
Date: Fri, 9 May 2008 21:27:04 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Ralf Baechle <ralf@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 2/4] RTC: SWARM I2C board initialization
In-Reply-To: <20080509092835.3bbf0f55@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805092054030.10552@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070031410.16173@cliff.in.clinika.pl>
 <20080507085953.2c08b854@hyperion.delvare> <Pine.LNX.4.55.0805072145040.25644@cliff.in.clinika.pl>
 <20080508105905.3209c659@hyperion.delvare> <Pine.LNX.4.55.0805082344040.5944@cliff.in.clinika.pl>
 <20080509092835.3bbf0f55@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Let me just quote you:
> 
> "This is mostly habitual -- this is what the GNU Coding Standard specifies
> for comments and which is enforced for GNU software which I have dealt a
> lot with."
> 
> You didn't say it was common sense. You did say that it was what the
> GNU Coding Standard specified, and as a consequence, what you were used
> to. So please keep your "oh come on" for yourself, you pointed the
> discussion in this direction yourself.

 Well, I take no habits that make no sense in the first place.  And I have
gone into great lengths to explain and justify what drives me in this case
-- I got it from the GNU standard and got convinced it is good, so I got
to using it.  I can write comments according to a different style, no
problem (as long as there is any defined style for a given case), but I
have to put some explicit effort into it.

 Similarly, habitually I write code in the Linux indentation style because
I like it, but I can use your hated GNU style (or any other that follows
any recognisable rules) as well, except I have to put some brainpower into
it.

> What matters is not "the pieces of code I am interested in", but the
> pieces of code _you_ are the master of, or not. As explained somewhere
> else in this thread, you are free to use whatever style you like (as
> long as it complies with Documentation/CodingStyle, that is) in new
> code you write and in code you maintain. For all the rest, you should
> stick to the surrounding style. This is common sense, as you'd say.

 Well, sorry, but I could only sense the lack of style in this piece of
code, which is why I tried to apply some.  You are free to disagree and as
you have undertaken maintenance of this area I am going to respect it.

> BTW, i2c-sibyte should be converted to a proper platform driver, so
> that only platforms with such a device instantiate it.

 The whole of SiByte support should eventually get converted to implement
platform initialisation.  I started some of this with changes to the
sb1250-mac.c Ethernet driver sometime in 2006, but no further progress has 
been made since.  I have other priorities higher on the list, but I have 
not forgotten about it and will come back at some point unless someone 
else does it first.

> Which legacy driver, "eeprom"? You should probably look into David
> Brownell's at24c driver:
> http://lists.lm-sensors.org/pipermail/i2c/2008-April/003307.html
> If it gets enough attention and testing, it could go upstream quickly.

 I can see if I can find a couple of cycles to spare and give this piece
of code a shot with my SWARM.  There is a pair of 128kB EEPROM chips
onboard (one as a bootstrap option and one to store configuration) and I
have two SDRAM modules installed providing another pair of a smaller size.

  Maciej
