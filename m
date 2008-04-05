Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYDEPdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYDEPdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 11:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYDEPdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 11:33:45 -0400
Received: from nn7.de ([85.214.94.156]:42309 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYDEPdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 11:33:44 -0400
Subject: Re: 2.6.25 intended change: smc:kbd_backlight vs.
	smc::kbd_backlight ?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Justin Mattock <justinmattock@gmail.com>, Julien BLACHE <jb@jblache.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1207392125.5021.11.camel@dax.rpnet.com>
References: <1207162690.9669.11.camel@localhost>
	 <1207292068.4511.10.camel@localhost>
	 <dd18b0c30804040812x76f99af7o99fa57c9a1ec10bc@mail.gmail.com>
	 <1207373556.10237.2.camel@localhost>
	 <1207392125.5021.11.camel@dax.rpnet.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 05 Apr 2008 17:33:40 +0200
Message-Id: <1207409620.4224.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-05 at 11:42 +0100, Richard Purdie wrote:
> On Sat, 2008-04-05 at 07:32 +0200, Soeren Sonnenburg wrote:
> > On Fri, 2008-04-04 at 15:12 +0000, Justin Mattock wrote:
> > > Hello; I noticed this as well, you loose the greatest feature; the
> > > cool leds lights on the keyboard with the macbook pro,
> > > A solution that worked for me was to compile pommed from the source
> > > and edit kbd_backlight.h
> > > regards;
> > >                Justin P. Mattock
> > 
> > Yeah, but it will not only affect pommed... and I don't see the
> > rationale of introducing :: to separate things... so I think we should
> > have another patch replacing the :: with ':' again to unbreak userspace
> > for 2.6.25.
> > 
> > Could someone more official please respond to this regression (CCing
> > Rafael to record it)
> 
> Basically the LED names were a mess, there is a documented standard
> which has been there since the beginning (Documentation/leds-class.txt)
> and a number of drivers didn't follow that. That standardisation commit
> was an attempt to deal with this problem once and for all and in that
> sense its a bugfix, not a regression. The fact function wasn't part of
> the original naming scheme was a mistake (see previous discussions on
> LKML) which we're trying to address without breaking the documented
> standard. The side effect is that some existing drivers need to be
> updated to match the documentation (and should never have been merged in
> the first place because of that) :(.

So to make it clear "devicename:colour:function" means in the case of
applesmc smc::kbd_backlight because there is no colour defined. One
could have used "devicename:function:colour" without breaking things -
no ?

So it seems we will have to file bug reports to the led dealing
userspace programs ...

Soeren
