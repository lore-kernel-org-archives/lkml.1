Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbXE3WMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbXE3WMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbXE3WME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:12:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:35450 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181AbXE3WMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:12:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XFUyG+v4n9kV1kAgEuf8G6g/w8nEiIbusP8hDk+u2i//v32zWjkfv3CLScC3FxtfUWZMPO/U4k4BjVld8Hf3oqNov1OfS82lQ9A8vlQ9EKsDSjqr1f7fUDKIy2N02ddgGfa5MoU9yW4iSkqxLbzfhhQ8KcDF66YDgN1R3KDzt/E=
Message-ID: <86802c440705301511vb8b2065xeb59e1b06aff2fea@mail.gmail.com>
Date: Wed, 30 May 2007 15:11:59 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Re: kexec and aacraid broken
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A551D3@otce2k301.adaptec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705301422h4e1fe90fra5a809cede5903a8@mail.gmail.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A551D3@otce2k301.adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> Yinghai Lu [mailto:yhlu.kernel@gmail.com] writes:
> > aacraid_commit_reset.patch is in the mainline already.
>
> But aacraid_commit_reset.patch is not in 2.6.22-rc3 (to which you report
> the issue). Does the aacraid_commit_reset.patch work to resolve this
> issue all by itself in the kexec'd kernel? Or alternatively did you try
> aacraid.startup_timeout=540 as one of the kernel parameters passed to
> the kexec'd kernel?

No, still get adapter kernel panic

>
> The '[PATCH] aacraid: fix shutdown handler to also disable interrupts'
> patch (you refer to this as patch 4) is not to be in the picture because
> it will hide the root cause. I believe I have you correct in stating
> that this patch (4) resolves the problem... but I expect the problem to
> remain with kdump.

Oh.
without patch(4), latest kernel still can use kexec to 2.6.21.3
will try to load 2.6.22-rc1 etc.

YH
