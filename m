Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbYDEKnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbYDEKnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 06:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYDEKmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 06:42:54 -0400
Received: from tim.rpsys.net ([194.106.48.114]:35472 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYDEKmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 06:42:53 -0400
Subject: Re: 2.6.25 intended change: smc:kbd_backlight vs.
	smc::kbd_backlight ?
From: Richard Purdie <rpurdie@rpsys.net>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Justin Mattock <justinmattock@gmail.com>, Julien BLACHE <jb@jblache.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1207373556.10237.2.camel@localhost>
References: <1207162690.9669.11.camel@localhost>
	 <1207292068.4511.10.camel@localhost>
	 <dd18b0c30804040812x76f99af7o99fa57c9a1ec10bc@mail.gmail.com>
	 <1207373556.10237.2.camel@localhost>
Content-Type: text/plain
Date: Sat, 05 Apr 2008 11:42:05 +0100
Message-Id: <1207392125.5021.11.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-05 at 07:32 +0200, Soeren Sonnenburg wrote:
> On Fri, 2008-04-04 at 15:12 +0000, Justin Mattock wrote:
> > Hello; I noticed this as well, you loose the greatest feature; the
> > cool leds lights on the keyboard with the macbook pro,
> > A solution that worked for me was to compile pommed from the source
> > and edit kbd_backlight.h
> > regards;
> >                Justin P. Mattock
> 
> Yeah, but it will not only affect pommed... and I don't see the
> rationale of introducing :: to separate things... so I think we should
> have another patch replacing the :: with ':' again to unbreak userspace
> for 2.6.25.
> 
> Could someone more official please respond to this regression (CCing
> Rafael to record it)

Basically the LED names were a mess, there is a documented standard
which has been there since the beginning (Documentation/leds-class.txt)
and a number of drivers didn't follow that. That standardisation commit
was an attempt to deal with this problem once and for all and in that
sense its a bugfix, not a regression. The fact function wasn't part of
the original naming scheme was a mistake (see previous discussions on
LKML) which we're trying to address without breaking the documented
standard. The side effect is that some existing drivers need to be
updated to match the documentation (and should never have been merged in
the first place because of that) :(.

Regards,

Richard


