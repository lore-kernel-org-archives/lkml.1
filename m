Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbYJQStP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbYJQStP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbYJQSsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:48:47 -0400
Received: from kroah.org ([198.145.64.141]:38527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754399AbYJQSsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:48:45 -0400
Date: Fri, 17 Oct 2008 10:40:52 -0700
From: Greg KH <greg@kroah.com>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017174052.GD2221@kroah.com>
References: <20081016002509.GA25868@kroah.com> <48F88923.30109@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F88923.30109@cateee.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 02:46:27PM +0200, Giacomo A. Catenazzi wrote:
> Greg KH wrote:
>> We number the kernel based on the year, and the numbers of releases we
>> have done this year:
>> 	YEAR.NUMBER.MINOR_RELEASE
>> For example, the first release in 2009 would be called:
>> 	2009.0.0
>> The second:
>> 	2009.1.0
>> If we want to be a bit more "non-zero-counting" friendly: we can start
>> at "1" for the number:
>> 	2009.1.0 for the first release
>> 	2009.2.0 for the second.
>> Then the stable releases can increment the minor number:
>> 	2009.1.1 for the first stable release
>> 	2009.1.2 for the second.
>> 	and so on.
>> Benefits of this is it more accuratly represents to people just how old
>> the kernel they are currently running is (2.6.9 would be have been
>> 2004.9.0 on this naming scheme.)
>> Yes, we can handle the major/minor macros in the kernel to provide a
>> compatible number so that automated scripts will not break, that's not a
>> big deal.
>> Any thoughts?
>
> What about:
> - rc releases: a 2009.5.0-rc4 become suddenly 2010.0.0-rc5 ?

Sure, what's the big deal?

> - a stable version in January of a kernel released in December
>   still has the old year? (I hope yes, but it could confuse users.)

stable versions would not modify the year.

> - when (if) we need a big innovative (or incompatible) kernel
>   change, how to mark old and new kernels?

Based on our current development model, this isn't an issue.

thanks,

greg k-h
