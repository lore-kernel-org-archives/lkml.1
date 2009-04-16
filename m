Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZDPUty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZDPUty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZDPUto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:49:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbZDPUto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:49:44 -0400
Date: Thu, 16 Apr 2009 13:37:48 -0700
From: Greg KH <gregkh@suse.de>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: hugh@veritas.com, arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk,
       viro@ZenIV.linux.org.uk, jmorris@namei.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
Message-ID: <20090416203748.GA24509@suse.de>
References: <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp> <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk> <200904130048.n3D0mw1f077050@www262.sakura.ne.jp> <Pine.LNX.4.64.0904141801300.24679@blonde.anvils> <200904150328.n3F3S0F9083222@www262.sakura.ne.jp> <Pine.LNX.4.64.0904152036150.27354@blonde.anvils> <200904160046.n3G0ki9o028612@www262.sakura.ne.jp> <Pine.LNX.4.64.0904160551080.28048@blonde.anvils> <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 02:35:11PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Hugh Dickins wrote:
> > I'd hoped to get confirmation that the mmap.c part of the patch
> > was all the extra needed; but never mind, that's clearly good.
> Yes. The mmap.c part solved khelper's current->mm == NULL warning.
> 
> > Thanks a lot: I'll send in a revert request,
> > and the acct_stack_growth patch, later today.
> Yes, please.

That's fine with me as well.  If distros care about this, they can
change the config option to be "" for HOTPLUG.

thanks,

greg k-h
