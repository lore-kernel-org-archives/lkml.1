Return-Path: <linux-kernel-owner+w=401wt.eu-S1031527AbXD1MdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031527AbXD1MdO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 08:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031528AbXD1MdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 08:33:14 -0400
Received: from mx34.mail.ru ([194.67.23.200]:15137 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031527AbXD1MdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 08:33:13 -0400
Date: Sat, 28 Apr 2007 16:31:29 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <gregkh@suse.de>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-ID: <20070428123129.GA2056@zarina>
Reply-To: cbou@mail.ru
References: <20070426232902.GA10423@zarina> <20070428045148.9f1ba191.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070428045148.9f1ba191.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 04:51:48AM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 03:29:02 +0400 Anton Vorontsov <cbou@mail.ru> wrote:
> 
> > To not confuse with David own battery-2.6 repository, it's called
> > battery2-2.6, and can be found here:
> > 
> > http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=summary
> > 
> > You can get it using "git clone --reference linux-2.6 \
> > git://git.infradead.org/users/cbou/battery2-2.6.git" command.
> 
> i386 `make allmodconfig':
> 
> ERROR: "battery_is_external_power_supplied" [drivers/battery/ds2760_battery.ko] undefined!
> ERROR: "battery_unregister" [drivers/battery/ds2760_battery.ko] undefined!
> ERROR: "battery_register" [drivers/battery/ds2760_battery.ko] undefined!
> ERROR: "battery_status_changed" [drivers/battery/ds2760_battery.ko] undefined!

:-/

It should be fixed 37 hours ago by

http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=commit;h=cbb1e1b9e3a2cbf62ce4c13ef95d146ebc5e7274

Should I ask git-pull when such fixes happens? And I wonder why it isn't
already in -mm, because you've added this git repository after that
commit...

Though, I'm doing "allmodconfig" once again, to be sure, it will take
some time. (I've done defconfig, with modular W1, BATTERY,
DS2760_BATTERY already, and error doesn't show up).

---

Also, much thanks for accepting it to the -mm.

I have one question though... battery2-2.6 have two branches,
"linus" (clean Linus' tree) and "master" (with battery stuff).

When I'll want to sync battery tree with Linus' once again,
should I just pull from linus, or it's better to rebase master against
linus, and then "git push -f" to the battery2-2.6 master branch?
Or it will break something on your side (as commits will change their
hash)?

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
