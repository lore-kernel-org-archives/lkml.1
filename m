Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYLDAwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYLDAwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbYLDAv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:51:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:49463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758544AbYLDAvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:51:55 -0500
Date: Wed, 3 Dec 2008 16:49:36 -0800
From: Greg KH <gregkh@suse.de>
To: edward_estabrook@agilent.com
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de,
       edward.estabrook@gmail.com, edward.estabrook.lkml@gmail.com
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
Message-ID: <20081204004936.GD6981@suse.de>
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 02:39:44PM -0700, edward_estabrook@agilent.com wrote:
> From: Edward Estabrook <Edward_Estabrook@agilent.com>
> 
> Here is a patch that adds the ability to dynamically allocate (and
> use) coherent DMA from userspace by extending the userspace IO driver.
> This patch applies against 2.6.28-rc6.

Hm, as this patch changes the UIO userspace/kernelspace interface, how
about also documenting it in the existing UIO documentation so that
people know it is there, and so that we can properly review if it is a
sane change.

ALso, for kernel/user api changes, you should cc: the
linux-api@vger.kernel.org mailing list so that it can be reviewed there
by the people trying to maintain the kernel documentation.

thanks,

greg k-h
