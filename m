Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbXFMEvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbXFMEvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 00:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXFMEvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 00:51:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:3708 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbXFMEvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 00:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WPMYQQCfsxwsKAAVgMcJq5Lt8tcaM6KDuhDC/2lOCeU+MpDIP3Bpnd+lEtLMaULSxU5piciRjhkAygLlVxWYoOtPITPpRq5hcCOyBUcq2mYjFxpKxYBjTW5avVdHDuYY+jNzDNCAtYXt1AL5K+Y2RMcuwGjMp+XnHK9nWSk6gW4=
Message-ID: <466F77AE.3050007@gmail.com>
Date: Wed, 13 Jun 2007 13:50:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cebbert@redhat.com, sandeen@redhat.com, maneesh@in.ibm.com,
       cs@tequila.co.jp
Subject: Re: [PATCHSET 2.6.22-rc4] sysfs: fix race conditions
References: <20070611050107.GJ29122@htj.dyndns.org> <20070610231203.730d0aba.akpm@linux-foundation.org> <466CE88B.2050803@gmail.com> <20070612234732.GA26286@kroah.com>
In-Reply-To: <20070612234732.GA26286@kroah.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jun 11, 2007 at 03:15:39PM +0900, Tejun Heo wrote:
>> Andrew Morton wrote:
>>>> This patchset contains three minimal backports of fixes in -mm.  With
>>>> all patches in the patchset and sysfs-races.patch applied, kernel
>>>> survived ~20 hours of stress test without any problem.
>>> So these are being proposed for 2.6.22?
>> Yeap.
>>
>>> I do wonder about Rafael's bug which he bisected down to
>>> gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch.
>>>
>>> If that won't be a problem in this patchset then I spose it's probably best
>>> to go ahead with a 2.6.22 merge, but it's more a Greg thing than a me
>>> thing.
>> I'm currently debugging that and it's irrelevant to these fixes.  The
>> bug is introduced far after the fixes.
>>
>>> I don't have a tree to merge these patches into, unless I drop all the
>>> patches which are in Greg's tree.
>>>
>>> Greg, can I leave it up to you to decide how we are to proceed here?
>> I can rebase all sysfs patches in -mm on top of linus#master + these
>> fixes if necessary.
> 
> Ok, I've sent these to Linus, so if he takes them, can you rebase your
> patches on top of this and resend the whole tree to me (or just the ones
> that needed to be modified, if that's easier.)

Sure thing.

> thanks again for this fix, I really appreciate it.

:-)

-- 
tejun
