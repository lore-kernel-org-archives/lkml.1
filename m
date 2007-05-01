Return-Path: <linux-kernel-owner+w=401wt.eu-S1160993AbXEAU4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160993AbXEAU4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161382AbXEAU4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:56:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1160993AbXEAU4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:56:02 -0400
Date: Tue, 1 May 2007 13:55:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21rc7-mm1 usb/sysfs oops.
Message-Id: <20070501135552.ab54be25.akpm@linux-foundation.org>
In-Reply-To: <20070501182301.GB2843@redhat.com>
References: <20070501182301.GB2843@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 14:23:01 -0400
Dave Jones <davej@redhat.com> wrote:

> I thought I'd try something really silly, and set up
> a raid5 stripe across 3 USB memory sticks just for giggles.
> 
> it worked just fine. Then I thought I'd be *really* clever
> and see how well raid5 reconstruction over same would behave,
> and yanked one out whilst the array was still 'up'.
> 
> *boom*.

Unfortunately rc7-mm1 and rc7-mm2 had dodgy-now-dropped sysfs changes in
it, so this might be a consequence of that.

> No more being a smart-ass for me today.

Would be good to test mainline instead, and/or -mm when Tejun's new sysfs
patches appear.  And cc linux-usb-devel and linux-scsi when it goes boom.


