Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZJ2BHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZJ2BHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbZJ2BHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:07:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083AbZJ2BHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:07:17 -0400
Date: Wed, 28 Oct 2009 18:04:19 -0700
From: Greg KH <gregkh@suse.de>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Brian Swetland <swetland@google.com>, Eric Miao <eric.miao@canonical.com>,
       kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Android logger: fix compiling error
Message-ID: <20091029010419.GA18410@suse.de>
References: <1256316741-14053-1-git-send-email-bryan.wu@canonical.com>
 <f17812d70910262140i63e4d2f0x708521a9287ca386@mail.gmail.com>
 <20091027140558.GA17208@suse.de>
 <4AE8E953.6090504@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE8E953.6090504@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 09:01:07AM +0800, Bryan Wu wrote:
> Greg KH wrote:
> > On Tue, Oct 27, 2009 at 12:40:07PM +0800, Eric Miao wrote:
> >>> Compiling broke since commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
> >>>    headers: remove sched.h from poll.h
> >>>
> >>> Adding <linux/sched.h> to fix this compiling bug.
> > 
> > I have now just marked the android drivers as broken, as this is not the
> > only build error in them at the moment :(
> > 
> 
> Yeah, actually the drivers/staging/android/lowmemorykiller.c has been
> failing to compile for a long time, because that struct mm_struct does
> not have a field named oom_adj. All the Android drivers are compiled
> as modules in Ubuntu kernel package, except this one.
> 
> Although Android public kernel is still in 2.6.29, it's own driver is
> totally different with our mainline staging version. Is there any plan
> to sync with it?

No, Google has abandoned any current effort to push code upstream for
the past year :(

The android drivers are deleted in linux-next and will go away in 2.6.33
because of this.

thanks,

greg k-h
