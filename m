Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYI1V2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYI1V2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 17:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYI1V2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 17:28:35 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46134 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752153AbYI1V2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 17:28:35 -0400
Date: Sun, 28 Sep 2008 16:28:34 -0500
From: Russ Anderson <rja@sgi.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 4/4] x86: Add sysfs entries for UV v2
Message-ID: <20080928212834.GB17681@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080926200343.GE138671@sgi.com> <20080928204701.GA5863@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928204701.GA5863@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 01:47:01PM -0700, Greg KH wrote:
> On Fri, Sep 26, 2008 at 03:03:43PM -0500, Russ Anderson wrote:
> > [PATCH 4/4] Add sysfs entries for UV
> > 
> > Create /sys/firmware/sgi_uv sysfs entries for partition_id and coherence_id.
> > The interface is documented in Documentation/ABI/testing/sysfs-firmware-sgi_uv.
> 
> It is?  I don't see that file in the patch:

It is already in Linus' tree.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8b3a8944a9c0f2a3afc1678798b44f0442924a37

> >  arch/x86/kernel/Makefile   |    2 -
> >  arch/x86/kernel/uv_sysfs.c |   72 +++++++++++++++++++++++++++++++++++++++++++++
> >  include/asm-x86/uv/bios.h  |    1 
> >  3 files changed, 74 insertions(+), 1 deletion(-)
> 
> Did you forget something?
> 
> thanks,
> 
> greg k-h

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
