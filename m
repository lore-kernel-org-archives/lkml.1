Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbYEETGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbYEETGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763824AbYEETFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:05:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:14514 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763810AbYEETFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jkBPd8ZOyJTTwyUpGEBSBQI3fI/cg121GL5NrLlVkg9Z3GvK4rPqgLUunlu9LEAe8pSFGcEY3zEzt7oQCD2mOwGWBXpnHFgvNtCCXMaW6jII3s3UVsN/9JMlrXRCqFY8/GJ244sLgHfv20WI1Zvf3FeEYYUy1iQGRHfU4wArXoA=
Message-ID: <481F5A90.5080109@henry.nestler.gmail.com>
Date: Mon, 05 May 2008 21:05:52 +0200
From: Henry Nestler <henry.nestler@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jesper Krogh <jesper@krogh.cc>
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <aoJcW-38V-37@gated-at.bofh.it> <aoWjI-1Br-5@gated-at.bofh.it> <aoYOH-6RO-13@gated-at.bofh.it> <ap5nc-3ZT-7@gated-at.bofh.it> <ap5Gx-4vu-43@gated-at.bofh.it> <ap9Ar-4Nn-21@gated-at.bofh.it> <aqcZe-7Fg-23@gated-at.bofh.it> <aqd98-7Vb-25@gated-at.bofh.it> <aqd99-7Vb-27@gated-at.bofh.it>
In-Reply-To: <aqd99-7Vb-27@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> Randy.Dunlap wrote:
>> On Mon, 5 May 2008, Jesper Krogh wrote:
>>
>>> Jesper Krogh wrote:
>>>> Ray Lee wrote:
>>>>> BTW, I may have missed this earlier, but does it happen *anywhere* on
>>>>> the troublesome filesystem (ie, in a newly created subdirectory)?
>>>> Yes. It is reproducible on a newly created subdirectory on the
>>>> filesystem.
>>> Now I've created a new filesystem. (resized the original LVM-volume to half
>>> and created a new ext3 one next to it). The problem persists on this new
>>> filesystem.
>>>
>>> Just guessing, can there be something timing related in clearing the FS-cache
>>> for the filesystem?
>>>
>>> Any other suggestions/pointers.
>> Hi,
>>
>> Has anyone else been able to reproduce this problem?
> 
> No, and out of my systems. I only have this external SCSI-IDE-raid 
> device I can reproduce it on. The internal system disks doesnt allow me 
> to reproduce it on the same installation.
> 

Can you create a set of empty files, made loop devices with 'losetup'
and create the LVM from it? This array then you can check on the
internal disk.

Second idea: What is, if you create an ext3 filesystem without LVM on
the troublefs?

-- 
Henry N.
