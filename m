Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZGWO6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZGWO6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZGWO6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:58:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52933 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbZGWO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:58:03 -0400
Date: Thu, 23 Jul 2009 16:57:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
Message-ID: <20090723145757.GB28158@elf.ucw.cz>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com> <20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com> <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com> <20090718103756.GA11381@elf.ucw.cz> <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com> <20090718235609.GC25343@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718235609.GC25343@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-07-18 20:56:10, Henrique de Moraes Holschuh wrote:
> On Sat, 18 Jul 2009, Luis R. Rodriguez wrote:
> > Hm yeah, but I doubt someone will do that, generally we'd get one wake
> > up event. Can't we just report the first one and ignore the rest?
> 
> Well, I'd say keeping it simple is best, here.  What if you ignore the more
> interesting wakeup events by chance (and it is really up to userspace to
> know what it considers interesting...)?  IMHO, just issue as many
> notifications as needed, let userspace filter it if it wants.
> 
> But if you guys are talking about something really generic, shouldn't it
> also provide the important "why" along with the "who"?
> 
> Even for the most common cases, the "why" is useful: userspace may well want
> to run special routines when it wakes up because of WoL and WoW (instead of
> a key press, lid open or mouse movement...).

What special routines?

Note that the "why" is unreliable by design. Network driver will
ignore WoL during run-time, right?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
