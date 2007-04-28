Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbXD1P7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbXD1P7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXD1P7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:59:39 -0400
Received: from mx33.mail.ru ([194.67.23.194]:28393 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbXD1P7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:59:38 -0400
Date: Sat, 28 Apr 2007 19:57:48 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <gregkh@suse.de>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-ID: <20070428155748.GA7679@zarina>
Reply-To: cbou@mail.ru
References: <20070426232902.GA10423@zarina> <20070428045148.9f1ba191.akpm@linux-foundation.org> <20070428123129.GA2056@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070428123129.GA2056@zarina>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 04:31:29PM +0400, Anton Vorontsov wrote:
> On Sat, Apr 28, 2007 at 04:51:48AM -0700, Andrew Morton wrote:
> > On Fri, 27 Apr 2007 03:29:02 +0400 Anton Vorontsov <cbou@mail.ru> wrote:
> > 
> > > To not confuse with David own battery-2.6 repository, it's called
> > > battery2-2.6, and can be found here:
> > > 
> > > http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=summary
> > > 
> > > You can get it using "git clone --reference linux-2.6 \
> > > git://git.infradead.org/users/cbou/battery2-2.6.git" command.
> > 
> > i386 `make allmodconfig':
> > 
> > ERROR: "battery_is_external_power_supplied" [drivers/battery/ds2760_battery.ko] undefined!
> > ERROR: "battery_unregister" [drivers/battery/ds2760_battery.ko] undefined!
> > ERROR: "battery_register" [drivers/battery/ds2760_battery.ko] undefined!
> > ERROR: "battery_status_changed" [drivers/battery/ds2760_battery.ko] undefined!
> 
> :-/
> 
> It should be fixed 37 hours ago by
> 
> http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=commit;h=cbb1e1b9e3a2cbf62ce4c13ef95d146ebc5e7274
[1]

> Though, I'm doing "allmodconfig" once again, to be sure, it will take
> some time. (I've done defconfig, with modular W1, BATTERY,
> DS2760_BATTERY already, and error doesn't show up).

Finally allmodconfig finished (yup, my machine is old and slow),
and no error happened. So, [1] should have been really fix this.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
