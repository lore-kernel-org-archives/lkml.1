Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZDTGRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZDTGRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZDTGQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:16:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:24363 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZDTGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:16:55 -0400
Message-ID: <49EC1352.6010900@petalogix.com>
Date: Mon, 20 Apr 2009 08:16:50 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Nate Straz <nate-ltp@refried.org>
CC: subrata@linux.vnet.ibm.com, ltp-list@lists.sourceforge.net,
       John Williams <john.williams@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [LTP] statvfs -> f_bavail
References: <49E759FB.70103@petalogix.com> <49E847FB.1030801@petalogix.com> <20090417173107.GA3590@refried.org>
In-Reply-To: <20090417173107.GA3590@refried.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nate Straz wrote:
> On Apr 17 11:12, Michal Simek wrote:
>   
>>> don't you know what is the description of f_bavail in struct statvfs?
>>> On my system I am getting zero for this entry that's why fsync02 failed.
>>>   
>>>       
>> I track down where the problem comes from.
>> There is problem for all fs which use simple_statfs function from
>> fs/libfs.c.
>> In open.c in vfs_statfs function is whole structure set to zero and then
>> in simple_statfs not set this value.
>> I think we should fix it in ltp code.
>> Here is my proposed change. If is ok - I will generate proper patch.
>>     
>
> If the problem is in the kernel, then it should be fixed in the kernel.
> That's the whole point of LTP, pointing out problems in the kernel which
> need to be fixed.  Patching LTP to work around f_bavail not being set
> correctly is not the right thing to do.
>   
:-) And what about if is the kernel code ok? :-)
Then IMHO is the right time to fix LTP.

The main question is if is or not.

Hi guys from linux-fsdevel: Can you told us what is the right solution
for my problem above?

Thanks,
Michal

> Nate
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

