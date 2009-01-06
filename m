Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZAFCSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZAFCSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZAFCSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:18:40 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:31383 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZAFCSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:18:39 -0500
Date: Mon, 5 Jan 2009 20:18:28 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Message-ID: <20090106021828.GA1099402@hiwaay.net>
References: <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com> <4960897D.5030603@davidnewall.com> <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm> <4961432A.80509@davidnewall.com> <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net> <4962BB13.7060304@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4962BB13.7060304@davidnewall.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, David Newall <davidn@davidnewall.com> said:
> We have this already; zoneinfo

How many times: zoneinfo is for offset from UTC, not changes in UTC.

> I haven't been able to find this Annex B that Alan talked of, so I can
> only go by the man page, which states, simply and explicitly, that
> time() returns seconds since Epoch, and also that Epoch is start of
> January 1 1970.  To my mind, time *does* recognise leap seconds.

Part of the rationale for SUSv3 (aka 1003.1-2001), xbd_chap04.html in my
copy:

   The topic of whether seconds since the Epoch should account for leap
   seconds has been debated on a number of occasions, and each time
   consensus was reached (with acknowledged dissent each time) that the
   majority of users are best served by treating all days identically.
   (That is, the majority of applications were judged to assume a single
   length-as measured in seconds since the Epoch-for all days. Thus,
   leap seconds are not applied to seconds since the Epoch.) Those
   applications which do care about leap seconds can determine how to
   handle them in whatever way those applications feel is best.  This
   was particularly emphasized because there was disagreement about what
   the best way of handling leap seconds might be. It is a practical
   impossibility to mandate that a conforming implementation must have a
   fixed relationship to any particular official clock (consider
   isolated systems, or systems performing "reruns" by setting the clock
   to some arbitrary time).

Now, you are wrong, the standard says so, please take this somewhere
else and stop CCing me.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
