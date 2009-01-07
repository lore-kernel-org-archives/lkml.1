Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbZAGR1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbZAGR1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZAGR13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:27:29 -0500
Received: from bsdimp.com ([199.45.160.85]:56960 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZAGR12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:27:28 -0500
Date: Wed, 07 Jan 2009 10:24:34 -0700 (MST)
Message-Id: <20090107.102434.-1980908153.imp@bsdimp.com>
To: davidn@davidnewall.com
Cc: linasvepstas@gmail.com, david@lang.hm, hancockr@shaw.ca,
       kyle@moffetthome.net, slashdot@jameshallam.info, goodgerster@gmail.com,
       mayer@ntp.isc.org, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, nick@nick-andrew.net, jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <49647E0F.9030008@davidnewall.com>
References: <49642674.9080703@ntp.isc.org>
	<3ae3aa420901062052h75fcab11n8ce45c41ac0e4cd2@mail.gmail.com>
	<49647E0F.9030008@davidnewall.com>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <49647E0F.9030008@davidnewall.com>
            David Newall <davidn@davidnewall.com> writes:
: Linas Vepstas wrote:
: > Currently, the Linux kernel keeps time in UTC. This means
: > that it must take special actions to tick twice when a leap
: > second comes by.
: 
: Except it doesn't have to tick twice.  Refer to
: http://lkml.org/lkml/2009/1/7/78 in which I show that a time_t (what
: time() returns) counts leap seconds (According to Bernstein this is what
: UTC means), and using zoneinfo, the library processes leap seconds
: correctly.

This is *NOT* POSIX time_t.  In order to be posix compliant, you can't
do what Bernstein suggests.  You can be non-complaint and deal it with
zoneinfo.

: I just realised that the Notes in man 2 time are confusing and probably
: unnecessary.  Suffice to say that (assuming correctly configured
: zoneinfo) time() returns the number of seconds elapsed since start 1970.

That's not POSIX complaint.

Warner
