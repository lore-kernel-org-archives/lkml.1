Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbYCVWJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbYCVWJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbYCVWJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:09:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757681AbYCVWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:09:05 -0400
Date: Sat, 22 Mar 2008 15:08:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-scsi@vger.kernel.org
Subject: Re: 2.6.25-rc6: kernel BUG at fs/sysfs/file.c:89
Message-Id: <20080322150848.bf165996.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.0803222128570.6948@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803212319130.17137@sheep.housecafe.de>
	<200803220226.35552.rjw@sisk.pl>
	<20080321222606.16407d74.akpm@linux-foundation.org>
	<alpine.DEB.1.00.0803221942050.4470@sheep.housecafe.de>
	<alpine.DEB.1.00.0803222128570.6948@sheep.housecafe.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008 22:54:51 +0100 (CET) Christian Kujau <lists@nerdbynature.de> wrote:

> On Sat, 22 Mar 2008, Christian Kujau wrote:
> >> If so, the below (already merged) patch should fix this crash.
> >> If this patch does not fix it then please apply this debug patch:
> >> http://userweb.kernel.org/~akpm/mmotm/broken-out/gregkh-driver-driver-core-debug-for-bad-dev_attr_show-return-value.patch
> >> then rerun the test.
> >
> > Ah, sorry, I misread your post: I applied the aforementioned dm-crypt 
> > patch[0] and Greg's debug patch and got quite nasty SCSI errors, leading to a 
> > complete lockup. I'll try again and only apply Neil's patch...stay tuned...
> 
> Hm, this was strange: I applied Neil's patch (and the dm-crypt patch) on 
> 2.6.25-rc6 and I kept getting SCSI errors (and lockups) when doing "tar 
> -cf - | dd of=/dev/null" - which I did to generate disk I/O.

Please send all the details about this, retaining all cc's.

