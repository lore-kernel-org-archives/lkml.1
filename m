Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbXEDKAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbXEDKAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXEDKAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:00:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49118 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754607AbXEDKAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:00:03 -0400
Date: Fri, 4 May 2007 11:59:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Shem Multinymous <multinymous@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070504095956.GB17455@elf.ucw.cz>
References: <20070411232503.GC20095@zarina> <20070413134939.GA20618@zarina> <20070415004354.GA23559@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415004354.GA23559@zarina>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'll convert mXh to uXh a bit later, if there will no further objections
> > against uXh. Also I'd like to hear if there any objections on
> > mA/mV -> uA/uV conversion. I think we'd better keep all units at the
> > same order/precision.
> 
> Okay, would it make sense to use "long" instead of "int" after "milli" to
> "micro" conversion? On 32 bit machines int gives +-2147483648 limit. So
> 2147 volts/amperes/...

long == int on 32bit machines.

> Though 2147 amperes is unrealistic for batteries, but if used in
> calculations it could be dangerous.

Let the one doing calculations handle that ;-).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
