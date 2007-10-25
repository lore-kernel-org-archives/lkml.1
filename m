Return-Path: <linux-kernel-owner+w=401wt.eu-S1761700AbXJYEIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761700AbXJYEIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbXJYEIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:08:35 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:52955 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXJYEIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:08:35 -0400
X-Greylist: delayed 1975 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 00:08:35 EDT
Message-ID: <47200F05.2050305@billgatliff.com>
Date: Wed, 24 Oct 2007 22:35:33 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk@arm.linux.org.uk>, bugme-daemon@bugzilla.kernel.org,
       svs1957@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 9217] New: CONFIG_CMDLINE doesn't pass to kernel
References: <bug-9217-10286@http.bugzilla.kernel.org/> <20071024195717.0de6a248.akpm@linux-foundation.org>
In-Reply-To: <20071024195717.0de6a248.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Something broke CONFIG_CMDLINE of ARM (at least) between 2.6.22 and 2.6.23.
>
> I don't know whether it was an ARM patch one of those kernel-wide changes. 
> We have futzed with the command-line parsing a bit recently, but the 2.6.23
> changelog doesn't suggest anything obvious.
>   

What does the affected system's bootloader pass in r2?  If it's nonzero, 
ARM's 2.6.23 may interpret it as being an ATAGS pointer.  And when that 
happens, the system prefers the ATAGS over CONFIG_CMDLINE.

There's sanity checking in __vet_atags, but maybe it isn't enough.  
Other than that, I can't see anything yet.


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com

