Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYAUIot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYAUIot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbYAUIoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:44:39 -0500
Received: from hs-out-0708.google.com ([64.233.178.250]:40939 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758159AbYAUIoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:44:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ri6MRPzDo77nDoZX2lshE8AKyrpbEvgUouRiCXg5vu34GslCfk5XgO7TG79X8RpLQzoSvRHKwkWsajWovwO+T0rYrnI90qvwSIMybd0NN3ZPNTZhx2QAQ8DfBvAgxpvJ9M4YanhENnR28d9Qosyynck1Jfng44xTjpEJCAXiqEo=
Message-ID: <a8e1da0801210044t5f705f77n8e310878775f7b5b@mail.gmail.com>
Date: Mon, 21 Jan 2008 16:44:36 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, "David Brownell" <david-b@pacbell.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080121083608.GA1789@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com>
	 <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com>
	 <20080118073836.GA1703@ff.dom.local>
	 <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com>
	 <20080118082327.GC1703@ff.dom.local>
	 <a8e1da0801180107w2d5a4be2r2b30d57a0d2b85ce@mail.gmail.com>
	 <4791C555.9050205@gmail.com>
	 <20080121013021.GB2832@darkstar.te-china.tietoenator.com>
	 <20080121014335.GA3219@darkstar.te-china.tietoenator.com>
	 <20080121083608.GA1789@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 21, 2008 4:36 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Mon, Jan 21, 2008 at 09:43:35AM +0800, Dave Young wrote:
> ...
> > Convert the class semaphore to mutex.
> > class_interface_register/unregister use class_device_* functions, so SINGLE_DEPTH_NESTING added for lockdep please in these functions.
>
> Looks fine to me now, but... I think you forgot again to make it
> clear that there were no lockdep warnings observed after this patch.
> And it seems there should be used something more complex than usb
> mouse or modem to verify this. Then IMHO it would be very nice if
> Andrew dares to merge this to -mm...

I applied it in my kernel, built and run without warnings, but it need
more testing.
I will be very glad to see the test result about this if you could, thanks.

>
> Regards,
> Jarek P.
>
> PS: I miss a lot function names in this patch...
>
