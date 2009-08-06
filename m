Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbZHFJxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbZHFJxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZHFJxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:53:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38415 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZHFJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:53:05 -0400
Date: Thu, 6 Aug 2009 11:52:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/3] Generic sysfs support for ACPI ALS and other ALS
	devices
Message-ID: <20090806095258.GA31370@elf.ucw.cz>
References: <1249290657.2670.250.camel@rzhang-dt> <20090804132129.GH18974@elf.ucw.cz> <1249434170.2670.386.camel@rzhang-dt> <20090805161931.GA9749@elf.ucw.cz> <1249522879.2670.480.camel@rzhang-dt> <20090806071353.GB21847@elf.ucw.cz> <1249548430.2670.517.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249548430.2670.517.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, so just export
> > 
> > ALS exports
> > 1. the current ambient light illuminance
> > 2. the current mapped ambient light illuminance
> > 
> In fact, only one attribute is enough.

Good. (I thought you would want to export the 1) too, mainly for debugging).

> The ALS driver can query the current illuminance, parse the mapping and
> only export the display luminance adjustment values to user space.

> then user space just needs to
> 1. set a brightness level as the base point
> 2. get the display adjustment value and calculate a proper brightness
> level at any time.
> 
> this is easier, but it makes me feel that this doesn't look like an
> _ALS_ device any more.
> We still should export some ALS properties to user space, shouldn't
> we?

Why? Just because ACPI specs is ugly does not mean we should make
Linux ugly, too. Please just use suggestion above.

> Could you please look at the documentation about ALS sysfs class in the
> patch I sent out just now, and comment on that one please? thanks!

I did. The interface is too ugly to live.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
