Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYJQMqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYJQMqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYJQMqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:46:39 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:46622 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbYJQMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:46:38 -0400
Message-ID: <48F88923.30109@cateee.net>
Date: Fri, 17 Oct 2008 14:46:27 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>
In-Reply-To: <20081016002509.GA25868@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> We number the kernel based on the year, and the numbers of releases we
> have done this year:
> 	YEAR.NUMBER.MINOR_RELEASE
> 
> For example, the first release in 2009 would be called:
> 	2009.0.0
> The second:
> 	2009.1.0
> 
> If we want to be a bit more "non-zero-counting" friendly: we can start
> at "1" for the number:
> 	2009.1.0 for the first release
> 	2009.2.0 for the second.
> 
> Then the stable releases can increment the minor number:
> 	2009.1.1 for the first stable release
> 	2009.1.2 for the second.
> 	and so on.
> 
> Benefits of this is it more accuratly represents to people just how old
> the kernel they are currently running is (2.6.9 would be have been
> 2004.9.0 on this naming scheme.)
> 
> Yes, we can handle the major/minor macros in the kernel to provide a
> compatible number so that automated scripts will not break, that's not a
> big deal.
> 
> Any thoughts?

What about:
- rc releases: a 2009.5.0-rc4 become suddenly 2010.0.0-rc5 ?
- a stable version in January of a kernel released in December
   still has the old year? (I hope yes, but it could confuse users.)
- when (if) we need a big innovative (or incompatible) kernel
   change, how to mark old and new kernels?

ciao
	cate
