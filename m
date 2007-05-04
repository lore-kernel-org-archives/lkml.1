Return-Path: <linux-kernel-owner+w=401wt.eu-S1423118AbXEDUHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423118AbXEDUHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161579AbXEDUHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:07:31 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:34549
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161569AbXEDUHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:07:30 -0400
Message-ID: <463BA0D8.3050403@microgate.com>
Date: Fri, 04 May 2007 15:08:40 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
References: <1178215277.4369.6.camel@amdx2.microgate.com> <20070503175305.e46ed8b7.akpm@linux-foundation.org>
In-Reply-To: <20070503175305.e46ed8b7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> In file included from drivers/char/synclink_gt.c:85:
> include/linux/synclink.h:175: error: expected specifier-qualifier-list before 'compat_ulong_t'
> 
> - We might as well do the same ifdef-avoidery trick around compat_ioctl()
>   too.  That required that it be renamed.
> 
> - It is fishy that apart from one outlier in kexec.h, synclink.h is the
>   only header file which uses compat_ulong_t.  Are we doing this right?

Arnd, do you have any comment on this?

It seems like the compatible types should be available
in something that is already commonly used like linux/types.h

I'm fine with it either way. I'm not in
a position to be making those kinds of decisions
for widely used infrastructure, so I'll leave
that for someone further up the food chain.

-- 
Paul Fulghum
Microgate Systems, Ltd.
