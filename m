Return-Path: <linux-kernel-owner+w=401wt.eu-S1762055AbZAGVmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055AbZAGVmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbZAGVmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:42:14 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:65222 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZAGVmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:42:13 -0500
Date: Wed, 7 Jan 2009 15:42:04 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Message-ID: <20090107214204.GA950819@hiwaay.net>
References: <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net> <4962BB13.7060304@davidnewall.com> <20090106025125.GB28431@mail.local.tull.net> <20090106094058.64c89586@lxorguk.ukuu.org.uk> <496479EA.1020207@davidnewall.com> <20090107095419.70b78dc7@lxorguk.ukuu.org.uk> <49648163.9060007@davidnewall.com> <20090107133306.GA1506277@hiwaay.net> <4964B7A0.3050900@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4964B7A0.3050900@davidnewall.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, David Newall <davidn@davidnewall.com> said:
> > - the standards say that time() returns seconds since the epoch in UTC
> >   _except_ explicity NOT including leap seconds
> 
> Don't believe everything you read.  For example, the time(2) man page
> says what POSIX does, but doesn't actually say that Linux also does the
> same.  It also says what you paraphrased above, but demonstrably that's
> not the case.  Man pages often are wrong in some details.  Hence RTSL.

I wasn't talking about man pages.  I already quoted the section from the
Single Unix Specification version 3 (which supersedes POSIX) that
explicitly says leap seconds are ignored (despite sometimes heated
disagreement, as seen repeated here).  The standard "seconds since the
epoch" is seconds since 1970-01-01 00:00:00 UTC but not including leap
seconds (00:00:00 UTC is always 86400*n seconds since the epoch).

As long as Linux wants to work like all the other POSIX systems (which
it should unless there is huge advantage in doing otherwise), time(),
gettimeofday(), etc., all must work without leap seconds.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
