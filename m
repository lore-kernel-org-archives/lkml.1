Return-Path: <linux-kernel-owner+w=401wt.eu-S2992474AbXCBOYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992474AbXCBOYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992477AbXCBOYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:24:24 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:34590 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992474AbXCBOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:24:23 -0500
X-IronPort-AV: i="4.14,241,1170651600"; 
   d="scan'208"; a="23341367:sNHT22777811"
Subject: Re: 2.6.21-rc2-mm1
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Fri, 02 Mar 2007 22:24:21 +0800
Message-Id: <1172845461.6055.12.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 03:00 -0800, Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> 
> 
> - Quite a lot of less-popular architectures still aren't compiling due
>   to utrace.  x86, x86_64, powerpc, ia64 and s390 should be OK.

In the latest blackfin-arch.patch, blackfin-arch should be OK with
utrace initial support. Maybe I messed up blackfin-arch-update.patch, I
will resend out the incremental patch later.

> - Added the KVM tree to the -mm lineup, as git-kvm.patch (Avi Kivity
>   <avi@qumranet.com>)
> 
> - git-mmc.patch got tempdropped due to disagreements with gcc
> 
> - Some of the x86_64 tree has been tossed out due to rejects
> 
> - The memory management changes in here to take mlocked and anon pages off
>   the LRU need a lot of testing before they can go into mainline.  I probably
>   do not have the time to do this.
> 
> - Nor am I likely to have time to review the blackfin architecture closely. 
>   Help is sought.

Thanks lot for this. Your help are highly appreciated by blackfin-Linux
team. And you can find our work and support in blackfin.uclinux.org.

Regards,
-Bryan Wu
