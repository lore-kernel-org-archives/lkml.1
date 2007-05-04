Return-Path: <linux-kernel-owner+w=401wt.eu-S1161609AbXEEBJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161609AbXEEBJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161630AbXEEBJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:09:51 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:40041
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161609AbXEEBJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:09:51 -0400
Message-ID: <463B84B9.4090105@microgate.com>
Date: Fri, 04 May 2007 13:08:41 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
References: <1178215277.4369.6.camel@amdx2.microgate.com> <20070504174811.f564ffb3.akpm@linux-foundation.org>
In-Reply-To: <20070504174811.f564ffb3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 03 May 2007 13:01:17 -0500
> Paul Fulghum <paulkf@microgate.com> wrote:
> 
>> Add compat_ioctl handler to synclink_gt driver.
> 
> i386 allmodconfig:
> 
> make[3]: *** No rule to make target `/usr/src/devel/usr/include/linux/.check.synclink.h', needed by `__headerscheck'.  Stop.
> 
> I got tired of this patch - I think I'll drop it.

This all seems to be related to the use of compat_ulong_t

Since my original patch worked fine using unsigned int,
how about I go back to that?


--
Paul
