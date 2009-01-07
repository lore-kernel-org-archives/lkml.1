Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbZAGNhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbZAGNhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbZAGNhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:37:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35400 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbZAGNho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:37:44 -0500
Date: Wed, 7 Jan 2009 13:37:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Adams <cmadams@hiwaay.net>
Cc: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
Message-ID: <20090107133746.63d2677b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090107133306.GA1506277@hiwaay.net>
References: <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	<49614835.7000505@davidnewall.com>
	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	<20090105143335.GC18055@mail.local.tull.net>
	<4962BB13.7060304@davidnewall.com>
	<20090106025125.GB28431@mail.local.tull.net>
	<20090106094058.64c89586@lxorguk.ukuu.org.uk>
	<496479EA.1020207@davidnewall.com>
	<20090107095419.70b78dc7@lxorguk.ukuu.org.uk>
	<49648163.9060007@davidnewall.com>
	<20090107133306.GA1506277@hiwaay.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - zoneinfo is for offset from UTC, leap seconds are changes in UTC

If you two would stop throwing toys at each other and read the glibc
documentation and source you might get somewhere.

> - the standards say that time() returns seconds since the epoch in UTC
>   _except_ explicity NOT including leap seconds

Glibc has timezone support for both leap second inclusive ("right" as
it calls them) and posix time offsets.

Alan
