Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYCYDdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYCYDdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 23:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYCYDdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 23:33:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9029 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbYCYDc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 23:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ma0/0aBQGCmu4gdl3H3vQS7Y277MFQ+LJTr+jT+w9pi1J3SKBb6VrrVYLndR2SBrTS2WsbOKiV+2jfq9mbEGiEZZiYdkBxYzx4UXIYQt/+a6f53DMYLPW/4kIDgaWVaKMysQkMt5InEifON7R8NKPBaf4Vibx/LizNGRMi12RtI=
Message-ID: <47E87261.4020603@gmail.com>
Date: Tue, 25 Mar 2008 12:32:49 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, kurt@roeckx.be,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc6] sata_promise: fix hardreset hotplug events,
 take 2
References: <200803221421.m2MEL1oY021558@harpo.it.uu.se> <18406.38445.717175.664615@harpo.it.uu.se> <47E70FB4.4010802@gmail.com> <47E86442.8030708@garzik.org> <47E86580.6050206@gmail.com>
In-Reply-To: <47E86580.6050206@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> Tejun Heo wrote:
>>> Acked-by: Tejun Heo <htejun@gmail.com>
>>>
>>> Jeff, do you want to merge this first?  If so, I'll update the
>>> prefer-hardreset and cleanup-sht-ops patchsets; otherwise, I'll massage
>>> this patch a bit so that it fits on top of those two patchsets.
>>
>> I just merged it into #upstream-fixes (answering your question)...  what
>> is your preferred method of sync'ing at this point?
> 
> Heh... me refreshing the patchset again.  Doing it right now.

Okay, updated.  Please pull from

  http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=shortlog;h=cleanup-sht-ops
  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git cleanup-sht-ops

It's now on top of the current #upstream-fixes (4cde32fc) and contains
the followings.

* prefer-hardreset patchset
* PCI-device-should-be-powered-up-before-being-accssed patch
* cleanup-sht-ops patchset

Thanks.

-- 
tejun
