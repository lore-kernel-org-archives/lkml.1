Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYKUKIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYKUKIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbYKUKIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:08:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:58630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbYKUKII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:08:08 -0500
Message-ID: <49268876.7080303@kernel.org>
Date: Fri, 21 Nov 2008 19:07:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations, take
 #2
References: <1227190298-4585-1-git-send-email-tj@kernel.org> <E1L3G3Q-0006SJ-Uc@pomaz-ex.szeredi.hu>
In-Reply-To: <E1L3G3Q-0006SJ-Uc@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Nov 2008 10:07:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

Miklos Szeredi wrote:
> Hi Tejun,
> 
> On Thu, 20 Nov 2008, Tejun Heo wrote:
>> This patchset is the second take of extend-FUSE patchset.  Changes
>> from the last take[L] are...
> 
> I managed to review and apply this and the libfuse patches up to the
> ioctl support.  After swithing _IOC_READ with _IOC_WRITE in the kernel
> the example program actually worked :)

Did I get that wrong?  Looking at it again.... oops.  It's reverse
alright.  Thanks for catching it.

> I removed ->unrestricted_ioctl() and associated code because it really
> doesn't make any sense: the high level lib won't be used for CUSE
> stuff, otherwise unrestrited ioctls are not allowed (and the interface
> is rather horrible anyway).

Well, CUSE highlevel interface piggy backs on FUSE so it requires
unrestricted_ioctl() there for it and ossp does use it.

> The poll patches look OK at a first glance too, I'll review them
> tomorrow.

Alright, thanks.

-- 
tejun
