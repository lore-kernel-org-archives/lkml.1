Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYCVSxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYCVSxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbYCVSww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:52:52 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:44523 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYCVSwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:52:51 -0400
Date: Sat, 22 Mar 2008 19:52:34 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: ext Andrew Morton <akpm@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
In-Reply-To: <20080321222606.16407d74.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.00.0803221942050.4470@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de> <200803220226.35552.rjw@sisk.pl> <20080321222606.16407d74.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, ext Andrew Morton wrote:
> Is MD (ie: raid) in use?

Yes, indeed. LUKS/dm-crypt on top of raid-1:

> If so, the below (already merged) patch should fix this crash.
> If this patch does not fix it then please apply this debug patch:
> http://userweb.kernel.org/~akpm/mmotm/broken-out/gregkh-driver-driver-core-debug-for-bad-dev_attr_show-return-value.patch
> then rerun the test.

Ah, sorry, I misread your post: I applied the aforementioned dm-crypt 
patch[0] and Greg's debug patch and got quite nasty SCSI errors, leading 
to a complete lockup. I'll try again and only apply Neil's patch...stay tuned...

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/3/17/214
[0] http://nerdbynature.de/bits/2.6.25-rc6/fill_read_buffer.log
-- 
BOFH excuse #197:

I'm sorry a pentium won't do, you need an SGI to connect with us.
