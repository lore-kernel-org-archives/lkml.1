Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZAKQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZAKQcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAKQb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:31:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:26901 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbZAKQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:31:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Fb2G8JocXPI9NDEMFMBT6hUTRgJTTHQoTE7RHmLgEY0egcjdQAZ1KHgHmmRcCk6Gzn
         0QPpcEL3XeaQPSuaHOUyNehCJesssuLRe9Re021/qHfdItbdcOjB1fxdSMEX7UekhxPo
         YZS2AZsYbc3N2pCzB6aijViT+eSDpNwVHvCCo=
Message-ID: <496A1EF3.20204@panasas.com>
Date: Sun, 11 Jan 2009 18:31:47 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: Re: current git kernel has strange problems during bisect
References: <200901111602.53082.borntraeger@de.ibm.com> <200901111607.59054.borntraeger@de.ibm.com> <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de> <200901111620.03345.borntraeger@de.ibm.com>
In-Reply-To: <200901111620.03345.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Sonntag 11 Januar 2009 schrieben Sie:
>> Hi,
>>
>> On Sun, 11 Jan 2009, Christian Borntraeger wrote:
>>
>>> Am Sonntag 11 Januar 2009 schrieb Christian Borntraeger:
>>>> doing a 
>>>> git bisect start
>>>> git bisect good a3a798c
>>>> git bisect bad v2.6.29-rc1
>>>>
>>>> results in a repository without several files, e.g Makefile!
>>>> git describe also fails.
>>> In fact, retesting with a clean repository shows, that there are only 
> btrfs 
>>> files - nothing else.
>>>
>>> Linus did you pull a broken btrfs repository?
>> I guess it is a subtree merge.  So no, nothing went wrong
>>
>> Use "git bisect skip" to skip over those.
> 
> I think we should really avoid merging subtrees to the linux kernel. It makes 
> bisecting a real PITA. 

Should is too soft, we cannot. What if it changes mainline files, they will
not have common ancestry. And also the sub-tree checkout un-checkout will take
ages. Chris must have merged with his subtree with a rebase not a merge. I suspect
Linus git tree will have to rebase. This is the first time I've seen such a merge.
for example see be0e5c097f it has no parent, and so on.

> Furthermore, It is unlikely, but what if the problem is part of the 581 
> changesets from btrfs?
> 

Exactly

> Christian
> --

Boaz
