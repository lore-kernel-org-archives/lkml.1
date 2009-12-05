Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbZLETJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbZLETJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 14:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932888AbZLETJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 14:09:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39516 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbZLETJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 14:09:15 -0500
Date: Sat, 5 Dec 2009 20:09:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>, J?rn Engel <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, arnd@arndb.de,
       tglx@linutonix.de
Subject: Re: XD/smartmedia - how to implement it right?
Message-ID: <20091205190913.GA1309@ucw.cz>
References: <109361.10237.qm@web37604.mail.mud.yahoo.com> <1259589517.13049.31.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259589517.13049.31.camel@maxim-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > First of all, thank you very much for your contributions.
> > > Could you explain, why we need an asynchronous mtd driver?
> > 
> > Because it's the future. ;-)
> Although I like the xD format, it has no future,
> Everyone migrated to SD now.
> 
> Reasons are very simple:
> 
> 1 - xD hardcodes device sizes, thus if somebody makes say 8GB card, many
> readers couldn't use it.
> I know that windows driver I was dealing with supports sizes up to 2GB
> 
> 
> 2 - xD is a nand card, but with 8-bit bus.
> Newer nand chips seem to favor 16 bit bus or more.
> Obviously, if they were to implement that it would be physically
> incompatible.
> 
> 3 - embedded cpus are cheap dirt now, and allow to use their, always
> 'better' FTL strategy, and also hide inner working of the chip.

XDs are still used by at least olympus digital cameras. Ouch.

If you have onboard embedded cpu, you can bet it will not work
correctly over powerfail. If you do FTL on host, you have at least
chance to get it right.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
