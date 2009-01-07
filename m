Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbZAGBR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbZAGBR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZAGBRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:17:21 -0500
Received: from vps1.tull.net ([66.180.172.116]:45210 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751072AbZAGBRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:17:21 -0500
Date: Wed, 7 Jan 2009 12:17:13 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Newall <davidn@davidnewall.com>,
       Linas Vepstas <linasvepstas@gmail.com>, david@lang.hm,
       Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years	2008-2009
Message-ID: <20090107011713.GA27527@mail.local.tull.net>
References: <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net> <4962BB13.7060304@davidnewall.com> <20090106025125.GB28431@mail.local.tull.net> <20090106094058.64c89586@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106094058.64c89586@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 09:40:58AM +0000, Alan Cox wrote:
> >        UTC  equivalent  to  conversion  on  the naive basis that leap seconds are ignored and all
> >        years divisible by 4 are leap years.  This value is not the same as the actual  number  of
> >        seconds between the time and the Epoch, because of leap seconds and because clocks are not
> >        required to be synchronized to a standard reference.
> 
> I'm not sure what you are quoting from but it is out of date on the
> subject of leap years.

"man 2 time" on Debian Lenny. The treatment of leap years looks ridiculous, but
within the context of a 32-bit time_t, all divisible-by-4 years between 1901 and
2038 are leap years. It's a bit of a problem for 64-bit time_t though.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
