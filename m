Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZAKBUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZAKBUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZAKBUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:20:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:59583 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752031AbZAKBUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:20:07 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/5DYIvPij5JbQF11VzMlxyrOT45cf5zke0K/beh/
	tAJPGrQJQQ1pvt
Date: Sun, 11 Jan 2009 02:20:06 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Richard Purdie <rpurdie@rpsys.net>
cc: Trent Piepho <xyzzy@speakeasy.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: [GIT PULL] LED updates for 2.6.29
In-Reply-To: <1231633983.5330.32.camel@dax.rpnet.com>
Message-ID: <Pine.LNX.4.64.0901110216030.24501@axis700.grange>
References: <1231500186.5317.9.camel@dax.rpnet.com> 
 <Pine.LNX.4.64.0901091231310.22972@t2.domain.actdsltmp> 
 <1231543199.5317.63.camel@dax.rpnet.com>  <Pine.LNX.4.58.0901100428230.1626@shell2.speakeasy.net>
 <1231633983.5330.32.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, Richard Purdie wrote:

> Ok, these are now queued in the LED tree:
> 
> http://git.o-hand.com/cgit.cgi/linux-rpurdie-leds/log/
> 
> I did merge the last three patches in one and make some changes to deal
> with some other outstanding issues. Let me know ASAP if there are any
> problems.

As already replied off-list, looks good mostly to me. Just have to keep in 
mind, that this version relies on drivers initialising their struct 
led_classdev instances to 0. Maybe it would be better to set the new 
max_brightness to 0 (or to LED_FULL) explicitly for them, as I was doing 
in my v2 of the patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
