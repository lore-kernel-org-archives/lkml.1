Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbXKHIT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbXKHIT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 03:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXKHITU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 03:19:20 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51883 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbXKHITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 03:19:20 -0500
Message-Id: <200711080819.lA88J8Pv072259@www262.sakura.ne.jp>
Subject: Re: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Nov 2007 17:19:08 +0900
References: <200711080257.lA82vQfA015942@www262.sakura.ne.jp> <20071107192211.c1c22e97.akpm@linux-foundation.org>
In-Reply-To: <20071107192211.c1c22e97.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thanks for reformatting my patch
and sorry for surprising you with directory name
(I meant to type linux-2.6.24-rc2, not linux-2.6.22-rc2).

According to linux-2.6.23,
it seems that I should return -ENOTDIR
for invalid args->nlen value.

I got a question here regarding interpretation of CTL_MAXNAME .
Is args->nlen == CTL_MAXNAME valid?
It is treated as invalid while the definition says

  /* how many path components do we allow in a
     call to sysctl?   In other words, what is
     the largest acceptable value for the nlen
     member of a struct __sysctl_args to have? */

If "name[CTL_MAXNAME];" is what the author intended,
I think args->nlen == CTL_MAXNAME is valid.

Regards.
