Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYK1VsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYK1VsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 16:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYK1Vru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 16:47:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:23828 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYK1Vrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 16:47:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=MAVJvTboiuEmzwo17XBRK+3z4EtiQ5Meq8LnJRiOW47RWkY67hs2itn1thLtbGZf4s
         jIeHpRmWtTJwO+qKoZ3TTJrXJr/p8J8vDMiouoP8MMMhY4qBjG9v29Ng5B9smU8kQlZq
         F1bIqQIVlIcSKIlk4nqrdYe3TBv++tyj8kyRI=
Message-ID: <cfd18e0f0811281340r2317a1e4y938e11da27a35558@mail.gmail.com>
Date: Fri, 28 Nov 2008 16:40:35 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Document sysfs interface to RTC system wakeup
Cc: "Jonathan Corbet" <corbet@lwn.net>,
       "kernel list" <linux-kernel@vger.kernel.org>, dl9pf@gmx.de,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20081126170032.GE10157@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081126161524.GD1983@elf.ucw.cz>
	 <20081126095610.13195e15@bike.lwn.net>
	 <20081126170032.GE10157@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 12:00 PM, Pavel Machek <pavel@suse.cz> wrote:
>> On Wed, 26 Nov 2008 17:15:24 +0100
>> Pavel Machek <pavel@suse.cz> wrote:
>>
>> > +How to use /sys/class/rtc/rtcX/wakealarm
>> > +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> > +This file takes the seconds since epoch to enable a wake event at the
>> > +specified time.
>>
>> More documentation is cool.  In this case, though, I'm left with an
>> immediate question: *why* am I interested in wakealarm?  Reading
>> through, I eventually figure out that it can maybe be used to get a
>> system to start up at some point in the future, maybe.  It seems like
>> that should be said at the outset.
>
> You can suspend/power down your machine, and it will power itself up
> at appropriate time.
>
>> Also; why do I want to migrate from /proc/acpi/alarm?
>
> Because /proc/acpi/alarm is ugly hack that is going to go away :-).

And these are the statements that (in slightly more polished terms)
should be in your doc ;-), in order to address Jonathan's quite
reasonable questions.
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
