Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYKVHaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYKVHaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYKVH3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:29:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:50297 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYKVH3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:29:52 -0500
Message-ID: <4927B4DB.1020802@kernel.org>
Date: Sat, 22 Nov 2008 16:29:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, greg@kroah.com
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in Userspace
References: <1227190983-5820-1-git-send-email-tj@kernel.org>	<1227190983-5820-6-git-send-email-tj@kernel.org>	<E1L3bA9-0000Dx-Vb@pomaz-ex.szeredi.hu>	<49279324.7010605@kernel.org> <20081121211756.a211d3a8.akpm@linux-foundation.org>
In-Reply-To: <20081121211756.a211d3a8.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 22 Nov 2008 07:29:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 22 Nov 2008 14:05:40 +0900 Tejun Heo <tj@kernel.org> wrote:
> 
>> Miklos Szeredi wrote:
>>> On Thu, 20 Nov 2008, Tejun Heo wrote:
>>>> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
>>>> index 0be9245..d4dcca8 100644
>>>> --- a/include/linux/miscdevice.h
>>>> +++ b/include/linux/miscdevice.h
>>>> @@ -28,6 +28,7 @@
>>>>  #define MPT_MINOR		220
>>>>  #define	HPET_MINOR		228
>>>>  #define FUSE_MINOR		229
>>>> +#define CUSE_MINOR		230
>>> This doesn't work: device numbers have to be allocated by LANANA.
>> My last attempt at LANANA for extended devt didn't get me anywhere and
>> I'm not sure LANANA is handling miscdevice minors at all.
> 
> No, I don't believe that miscdev minors are handled by lanana.
> 
> otoh, we've added only one new miscdev minor since 2005.  All the new
> code is using dynamic allocation.  Readers of your changelog and code
> comments will be wondering why you didn't do so ;)

Heh.. I suppose I was too attached to the module alias thing.  I'll
switch back to dynamic minor.

-- 
tejun
