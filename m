Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbYBCSU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbYBCSU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYBCSUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:20:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:1276 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYBCSUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:20:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HEOmuFunaPtwQzmRVDMR04VzV70mmcCan1gu4M1zNRrjIEnGRkZiYkGjbjC5RMgrEq49MSNuGmpGmijof33Jb88S7K/hykVxuDhdxtBPeY3Au7cnKLAfQ9crLktIf0KU5aPH2UCbeikGvGgmzU7U5eRe1Ye6NAIyfR1Tfvpfa6M=
Message-ID: <3d8471ca0802031020r4b735f27q83317ee8facf53cc@mail.gmail.com>
Date: Sun, 3 Feb 2008 19:20:46 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] proc: return -EPERM when preventing read of /proc/*/maps
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080104151931.GC27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080104135731.2908.90012.stgit@localhost.localdomain>
	 <20080104141443.GB27894@ZenIV.linux.org.uk>
	 <20080104153557.13e24970@inria.fr>
	 <20080104151931.GC27894@ZenIV.linux.org.uk>
X-Google-Sender-Auth: 25539af53730a512
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 4:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Umm...  Actually, m_next() and m_stop() both appear to be too convoluted.
>
> * m_next() never gets v == NULL
> * the only reason why we do that mmput et.al. both from ->next() and
>   ->stop() is that we try to avoid having priv->mm; why bother?
> * why the _hell_ is proc_maps_private defined in include/linux/proc_fs.h,
>   of all places?
> * while we are at it, why is it in any header at all?  Having that sucker
>   in task_mmu.c and task_nommu.c would be more than enough (and we'd avoid
>   that ifdef in definition, while we are at it).
>
> How about this:

Hi Al,

Any update on this patch?
As you completely rewrote it, I thought you would take care of pushing
it forward.

Thanks.

-- 
Guillaume
