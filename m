Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYI1VFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYI1VFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 17:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYI1VFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 17:05:47 -0400
Received: from [198.145.64.141] ([198.145.64.141]:59488 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751107AbYI1VFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 17:05:46 -0400
Date: Sun, 28 Sep 2008 13:47:01 -0700
From: Greg KH <greg@kroah.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 4/4] x86: Add sysfs entries for UV v2
Message-ID: <20080928204701.GA5863@kroah.com>
References: <20080926200343.GE138671@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926200343.GE138671@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 03:03:43PM -0500, Russ Anderson wrote:
> [PATCH 4/4] Add sysfs entries for UV
> 
> Create /sys/firmware/sgi_uv sysfs entries for partition_id and coherence_id.
> The interface is documented in Documentation/ABI/testing/sysfs-firmware-sgi_uv.

It is?  I don't see that file in the patch:

>  arch/x86/kernel/Makefile   |    2 -
>  arch/x86/kernel/uv_sysfs.c |   72 +++++++++++++++++++++++++++++++++++++++++++++
>  include/asm-x86/uv/bios.h  |    1 
>  3 files changed, 74 insertions(+), 1 deletion(-)

Did you forget something?

thanks,

greg k-h
