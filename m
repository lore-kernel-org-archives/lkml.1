Return-Path: <linux-kernel-owner+w=401wt.eu-S933861AbXHXB2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861AbXHXB2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 21:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765521AbXHXB2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 21:28:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:55035 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765446AbXHXB2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 21:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=s6BslxY1HHV91Vb2afqAkzGpuXk+a9sp/MFkDADy/iph1H66b/6E5y86zwO0A2hD1ColW8HUF91Wfbek9Gz8hVJYqIRwrmc1oyMczKonvM46G+EJWxgeQYCS14JlCoRIyRXVB+2xgRqxREVW51HY9Jjg6t+X7WwYdHW6YcOAD+c=
Message-ID: <46CE33DA.9010501@googlemail.com>
Date: Fri, 24 Aug 2007 03:26:50 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Joel Fuster <j@fuster.org>, linux-kernel@vger.kernel.org
Subject: Re: sysfs_dir_cache growing out of control
References: <46CCD3DF.4080303@fuster.org> <46CD057C.3080106@fuster.org> <20070823095933.GA6742@kroah.com> <46CE29DA.60409@fuster.org> <20070824005429.GA32265@kroah.com>
In-Reply-To: <20070824005429.GA32265@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 23, 2007 at 08:44:10PM -0400, Joel Fuster wrote:
>> Greg KH wrote:
>>> On Wed, Aug 22, 2007 at 11:56:44PM -0400, Joel Fuster wrote:
>>>> Joel Fuster wrote:
>>>>> Hi,
>>>>> I am running 2.6.22.3.  For reasons that escape me, over time (days) the 
>>>>> sysfs_dir_cache, dentry, and inode_cache SLUB entries grow until they 
>>>>> consume all the memory on my system, requiring a reboot.
>>> Hm, those items should consume all the memory, but it should be freed if
>>> you have memory pressure from other places.  Does it cause the machine
>>> to lock up, or you just got scared when seeing them?
>> Right.  The problem is that the memory never seems to get freed no matter 
>> what I do.  I've tried setting /proc/sys/vm/vfs_cache_pressure to 10000, 
>> but after a few days all my programs are running out of swap and I have to 
>> reboot to get things back to a usable state.
>>
>>> Oh, and does the same thing happen if you do not use SLUB, but rather
>>> the older SLAB?
>> OK I just rebuilt 2.6.22.3 with SLAB and I seem to be getting the same 
>> result..obviously I haven't waited several days, but 
>> sysfs_dir_cache/dentry/inode_cache grow continuously when scanbuttond is 
>> running, and stop growing when it isn't.
> 
> Do you have a pointer to the scanbuttond source code?  I'll try to take
> a look at this tomorrow.
> 

I guess this one :

https://sourceforge.net/projects/scanbuttond/

> thanks,
> 
> greg k-h
> -


Gabriel
