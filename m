Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYDEFcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYDEFcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 01:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYDEFcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 01:32:41 -0400
Received: from nn7.de ([85.214.94.156]:54643 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYDEFck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 01:32:40 -0400
Subject: Re: 2.6.25 intended change: smc:kbd_backlight vs.
	smc::kbd_backlight ?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Justin Mattock <justinmattock@gmail.com>
Cc: rpurdie@rpsys.net, Julien BLACHE <jb@jblache.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>
In-Reply-To: <dd18b0c30804040812x76f99af7o99fa57c9a1ec10bc@mail.gmail.com>
References: <1207162690.9669.11.camel@localhost>
	 <1207292068.4511.10.camel@localhost>
	 <dd18b0c30804040812x76f99af7o99fa57c9a1ec10bc@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 05 Apr 2008 07:32:36 +0200
Message-Id: <1207373556.10237.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 15:12 +0000, Justin Mattock wrote:
> Hello; I noticed this as well, you loose the greatest feature; the
> cool leds lights on the keyboard with the macbook pro,
> A solution that worked for me was to compile pommed from the source
> and edit kbd_backlight.h
> regards;
>                Justin P. Mattock

Yeah, but it will not only affect pommed... and I don't see the
rationale of introducing :: to separate things... so I think we should
have another patch replacing the :: with ':' again to unbreak userspace
for 2.6.25.

Could someone more official please respond to this regression (CCing
Rafael to record it)

Soeren

> On Fri, Apr 4, 2008 at 6:54 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> > On Wed, 2008-04-02 at 20:58 +0200, Soeren Sonnenburg wrote:
> >  > Dear all,
> >  >
> >  > I am wondering whether the change from
> >  >
> >  > /sys/devices/platform/applesmc.768/leds/smc:kbd_backlight  (2.6.24)
> >  > /sys/devices/platform/applesmc.768/leds/smc::kbd_backlight (2.6.25)
> >  >
> >  > is intentional?
> >  >
> >  > I recognized that it breaks current userspace applications changing the
> >  > keyboard background leds like pommed...
> >
> >  OK it looks like commit 6c152beefbf90579d21afc4f7e075b1f801f9a75 from
> >  Richard Purdie, 'leds: Standardise LED naming scheme' introduced this
> >  change.
> >
> >  Why do we need '::' instead of a single ':' (that would not have broken
> >  things)?
> >
> >  Also sometimes only a single ':' seperator is used like in
> >  corgi:green:mail but e.g. not in clevo::mail ?!
> >
> >  Soeren
> >  --
> >  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >  the body of a message to majordomo@vger.kernel.org
> >  More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >  Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
