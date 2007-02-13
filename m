Return-Path: <linux-kernel-owner+w=401wt.eu-S1751100AbXBMVmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbXBMVmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXBMVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:42:54 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:43408 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbXBMVmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:42:53 -0500
Date: Tue, 13 Feb 2007 23:42:52 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: User tools for March 11
Message-ID: <20070213214252.GI3438@mea-ext.zmailer.org>
References: <Pine.LNX.4.61.0702131607590.27065@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702131607590.27065@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 04:19:59PM -0500, linux-os (Dick Johnson) wrote:
> Hi!
> In the United States, some idiots have decided that the year 2000 scare
> wasn't enough so they changed the start date for daylight savings time
> from the first Sunday in April to the second Sunday in March.
> Does anybody know if there are new tools like `hwclock` and `date`?
> Will new 'C' runtime libraries be necessary as well?

Dick,

UNIXes use UTC internally which has no DST, but for userspace there is
"tzdata" package (with that name in Fedora, at least.)

* Fri Jan 06 2006 Petr Machata <pmachata@redhat.com> 2005r-2
- 2005r
  - Zones EST, MST, HST, EST5EDT, CST6CDT, MST7MDT, PST8PDT moved to
    northamerica to guard against old files with obsolete information
    being left in the time zone binary directory.
  - Changes for countries that are supposed to join 2007 US DST
    change.  This includes most of Canada, however entries already in
    the database (Alberta, British Columbia, Newfoundland, Northwest
    Territories, and Yukon) were left alone for the time being.
  - Fixes in zdump.c (abbrok): conditions are chained, and the string
    is checked for emptiness.

.. and many alterations since then.

So..  you may already have it in your system.  If not, just update that
one package.

> Cheers,
> Dick Johnson

/Matti Aarnio
