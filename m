Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYKVHmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYKVHmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYKVHmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:42:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:53806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYKVHmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:42:42 -0500
Message-ID: <4927B7E3.8090006@kernel.org>
Date: Sat, 22 Nov 2008 16:42:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations, take
 #2
References: <1227190298-4585-1-git-send-email-tj@kernel.org> <E1L3G3Q-0006SJ-Uc@pomaz-ex.szeredi.hu> <49268876.7080303@kernel.org>
In-Reply-To: <49268876.7080303@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 22 Nov 2008 07:42:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Miklos.
> 
> Miklos Szeredi wrote:
>> Hi Tejun,
>>
>> On Thu, 20 Nov 2008, Tejun Heo wrote:
>>> This patchset is the second take of extend-FUSE patchset.  Changes
>>> from the last take[L] are...
>> I managed to review and apply this and the libfuse patches up to the
>> ioctl support.  After swithing _IOC_READ with _IOC_WRITE in the kernel
>> the example program actually worked :)
> 
> Did I get that wrong?  Looking at it again.... oops.  It's reverse
> alright.  Thanks for catching it.

Now I know why it happened.  I caught the bug and fixed during testing
but the fix ended up in the following patch of implement-CUSE patchset.

  [PATCH 2/5] FUSE: export symbols to be used by CUSE

So, with it fixed in the right place, the above patch will produce one
reject.  I'll post a regenerated one.

Thanks.

-- 
tejun
