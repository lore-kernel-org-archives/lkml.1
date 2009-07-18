Return-Path: <linux-kernel-owner+w=401wt.eu-S1751344AbZGRLvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbZGRLvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZGRLvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:51:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32907 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZGRLv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:51:26 -0400
Date: Sat, 18 Jul 2009 13:50:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, mingo@elte.hu, tglx@linutronix.de,
       hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add function to convert between calendar time and
	broken-down time for universal use
Message-ID: <20090718115019.GH1433@ucw.cz>
References: <4A5C3BC0.6020701@cn.fujitsu.com> <20090714151040.b7b3b26d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714151040.b7b3b26d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +extern void gmtime(__kernel_time_t totalsecs,
> > +        unsigned int *year, unsigned int *mon, unsigned int *mday,
> > +        unsigned int *hour, unsigned int *min, unsigned int *sec,
> > +        unsigned int *wday, unsigned int *yday);
> > +extern void localtime(__kernel_time_t totalsecs,
> > +        unsigned int *year, unsigned int *mon, unsigned int *mday,
> > +        unsigned int *hour, unsigned int *min, unsigned int *sec,
> > +        unsigned int *wday, unsigned int *yday);


Should year/mon/.../yday be passed up as a structure?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
