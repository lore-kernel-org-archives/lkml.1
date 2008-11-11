Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYKKIiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYKKIiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYKKIhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:37:48 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:51989 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbYKKIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:37:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oXYL6gbns0gxfWoqSIUx7z45vRWt3Ki8atQOt+xxtWOPr61fa5Xh74j0wnauR+t2pd
         3pJcJ998zPM12xSNK5oP5eV6bMjNR6KcQs1bwShHbslu89ecogwV7UPrpwEXguwfg646
         lcaZke3jKcbGXfD9vT8qsui0rlzDFm8lShYy4=
Message-ID: <21d7e9970811110037l49e7b28bl2480863682cda0c@mail.gmail.com>
Date: Tue, 11 Nov 2008 18:37:46 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [git pull] drm fixes for 2.6.27-rc5
Cc: "Dave Airlie" <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
In-Reply-To: <20081111002958.7620fb56.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.0.82.0811110811350.2182@skynet.skynet.ie>
	 <20081111002958.7620fb56.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 6:29 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 11 Nov 2008 08:15:26 +0000 (GMT) Dave Airlie <airlied@linux.ie> wrote:
>
>> commit 78538bf14995a136c2d9a22159ada49937359119
>> Author: Dave Airlie <airlied@linux.ie>
>> Date:   Tue Nov 11 17:56:16 2008 +1000
>>
>>     drm/radeon: map registers at load time
>>
>>     Now that the radeon driver has suspend/resume functions, it needs to map its
>>     registers at load time or it will likely crash if a suspend operation occurs
>>     before the driver has been initialized.
>>
>>     This patch moves the register mapping code from firstopen to load and makes
>>     the mapping into a _DRM_DRIVER one so that the core won't remove it at
>>     lastclose time.
>
> Does this make the below patch obsolete?

Yes please drop this, the correct fix is the one Jesse posted + a fix
on top of it I made in the same patch.

>>     Fixes (at least partially) kernel bz #11891.
>
> A little thing: there are (or used to be) people who troll commits for
> bugzilla reports to close off.  I've adopted the convention of
> indicating bugzilla reports via their full URL to make those efforts
> easier and to increase their accuracy.
>

Cool will try that in future.

Dave.
