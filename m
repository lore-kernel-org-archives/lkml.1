Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZGWTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZGWTvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZGWTvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:51:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44828 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbZGWTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:51:21 -0400
Date: Thu, 23 Jul 2009 21:51:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
Message-ID: <20090723195114.GR28158@elf.ucw.cz>
References: <20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com> <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com> <20090718103756.GA11381@elf.ucw.cz> <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com> <20090718235609.GC25343@khazad-dum.debian.net> <20090723145757.GB28158@elf.ucw.cz> <20090723185720.GB19369@khazad-dum.debian.net> <20090723191330.GQ28158@elf.ucw.cz> <20090723194522.GC19369@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090723194522.GC19369@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-23 16:45:22, Henrique de Moraes Holschuh wrote:
> On Thu, 23 Jul 2009, Pavel Machek wrote:
> > > > Note that the "why" is unreliable by design. Network driver will
> > > > ignore WoL during run-time, right?
> > > 
> > > "Why" is unrealible?  I don't follow your reasoning.  It should be as
> > > reliable as "who"...
> > 
> > See above. The wakeup events race with each other.
> 
> We deliver them all.  It is that simple.  The rest is up to userspace.

Ok, but then we should not be talking about wake up events,
but... events.

Like "lid opened", "wake packet came", ... . And deliver them even
when they happen during run-time. That's okay with me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
