Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYKLJag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYKLJag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKLJa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:30:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:47894 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbYKLJa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:30:27 -0500
Message-ID: <491AA222.10209@kernel.org>
Date: Wed, 12 Nov 2008 18:30:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491A96AE.3080600@kernel.org> <20081112091416.GA19721@infradead.org>
In-Reply-To: <20081112091416.GA19721@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 12 Nov 2008 09:30:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Nov 12, 2008 at 05:41:18PM +0900, Tejun Heo wrote:
>>> emulated char devices to be char devices?  What I mean is, what would
>>> happen if instead of a char device /dev/dsp would be a regular file
>>> mounted on /dev/dsp (which implements all the necessary interfaces:
>>> ioctls, poll, etc)?
>> For most it would work, I suppose, but there are all sorts of wonky
>> users out in the wild (and quite a few that we don't have source access
>> to) and different configurations, so I think it's better to appear as
>> proper character device if it is a character device.  It will also help
>> udev and other desktop thingies deal with devices implemented in userland.
> 
> Note that mounting a char device on /dev/dsp is exactly the same as
> mounting a regular file on /dev/dsp - the only difference is what you
> set i_mode to.

A difference is how the device is located.  With proper character device
emulation, any char device node on any filesystem would work.  Not sure
how relevant that would be tho.

Thanks.

-- 
tejun
