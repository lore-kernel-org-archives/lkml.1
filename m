Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbZKLQzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbZKLQzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZKLQy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:54:58 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:40843 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZKLQy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:54:58 -0500
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 11:54:58 EST
Date: Thu, 12 Nov 2009 11:19:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Arve Hj?nnev?g <arve@android.com>, Brian Swetland <swetland@google.com>
Subject: Re: drivers/video/msm: update to new kernel
Message-ID: <20091112101902.GA11980@elf.ucw.cz>
References: <20091022085639.GA30548@elf.ucw.cz>
 <20091103161733.970b885f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103161733.970b885f.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-03 16:17:33, Andrew Morton wrote:
> On Thu, 22 Oct 2009 10:56:39 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > TASK_INTERRUPTIBLE and friends are now only available after including
> > <linux/sched.h>, so include it when needed.
> > 
> > bus_id is no longer available/neccessary, so remove that.
> > 
> > Android pmem driver is not available in mainline, so remove its hooks
> > from drivers/video.
> > 
> 
> What is the impact of these changes?
> 
> #2 looks like it's a build fix.  #3 looks like it isn't a build fix. 
> #1 is a mystery.

Well, it now compiles. #1... I guess something changed in arm headers
and explicit include of <linux/sched.h> became neccessary. #3 not all
usages of pmem were protected with #ifdef ...PMEM, breaking
compilation. And as PMEM is not in mainline, it seemed right to just
remove it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
