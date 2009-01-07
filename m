Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZAGNdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZAGNdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbZAGNdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:33:16 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:33108 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbZAGNdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:33:15 -0500
Date: Wed, 7 Jan 2009 07:33:06 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Message-ID: <20090107133306.GA1506277@hiwaay.net>
References: <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm> <49614835.7000505@davidnewall.com> <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com> <20090105143335.GC18055@mail.local.tull.net> <4962BB13.7060304@davidnewall.com> <20090106025125.GB28431@mail.local.tull.net> <20090106094058.64c89586@lxorguk.ukuu.org.uk> <496479EA.1020207@davidnewall.com> <20090107095419.70b78dc7@lxorguk.ukuu.org.uk> <49648163.9060007@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49648163.9060007@davidnewall.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, David Newall <davidn@davidnewall.com> said:
> The remaining fly in the ointment, if indeed the NTP client doesn't
> already do what I've outlined, is that leap seconds aren't reckoned into
> NTP broadcasts.  As intimated, this is correctable using leap second
> information from zoneinfo.

No it isn't; you are still wrong.  Yet again, you are ignoring the
facts:

- zoneinfo is for offset from UTC, leap seconds are changes in UTC

- the standards say that time() returns seconds since the epoch in UTC
  _except_ explicity NOT including leap seconds

- NTP already has a way to distribute leap second information to trusted
  clients

> Even though this is manifestly not a kernel issue, I'll work up a patch
> for ntpdate (apparently what I use) and post her, which I'm sure will be
> useful for all other NTP clients.

ntpdate is obsolete.

> However it is now clear that no special kernel support is required for
> leap-seconds, and any such code that's been incorporated needs to be
> removed.  Removed I say!

And you are wrong.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
