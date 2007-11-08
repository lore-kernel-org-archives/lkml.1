Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXKHIRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXKHIRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 03:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXKHIRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 03:17:13 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50962 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXKHIRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 03:17:12 -0500
X-Greylist: delayed 97917 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2007 03:17:12 EST
Date: Thu, 08 Nov 2007 17:16:42 +0900
From: Yuichi Nakamura <ynakam@hitachisoft.jp>
To: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [patch] audit support for SH
Cc: ynakam@hitachisoft.jp, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net, lethal@linux-sh.org,
       Al Viro <aviro@redhat.com>
In-Reply-To: <200711071015.33765.sgrubb@redhat.com>
References: <20071107135743.C1BD.YNAKAM@hitachisoft.jp> <200711071015.33765.sgrubb@redhat.com>
Message-Id: <20071108171026.5CD5.YNAKAM@hitachisoft.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.31 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007 10:15:33 -0500
Steve Grubb  wrote:
> On Wednesday 07 November 2007 12:04:46 am Yuichi Nakamura wrote:
> > I found syscall audit does not work on SH(SuperH).
> > I made patch to support syscall audit for SH.
> 
> I think this is close, but it looks like you missed the syscall classification 
> piece. You can find an example here:
> 
> arch/x86_64/kernel/audit.c
> 
> Its used for determining which syscalls we are interested in for watches. 
Thanks, I did not know that.
arch/sh is 32 bit only, so I think lib/audit.c is enough for sh.


> Also, IBM and HP both have released audit test suites. You should run the CAPP 
> tests at a minimum to see if you have hooked everything that is expected. If 
> you have SE Linux enabled for that platform, you may want to try the LSPP 
> tests but you would need have the MLS policy installed.
> 
> IBM's announcement is here:
> 
> https://www.redhat.com/archives/redhat-lspp/2007-August/msg00002.html
> 
> and HP's here:
> 
> https://www.redhat.com/archives/linux-audit/2007-August/msg00030.html
> 
> And...user space would need an update for the syscall table and arches so that 
> you can run the tests. Please send that patch to linux-audit mail list.
> 
> Thanks,
> -Steve

-- 
Yuichi Nakamura
Hitachi Software Engineering Co., Ltd.
Japan SELinux Users Group(JSELUG): http://www.selinux.gr.jp/
SELinux Policy Editor: http://seedit.sourceforge.net/

