Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYHTNcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYHTNcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYHTNcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:32:05 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:39968 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYHTNcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wFCm50/43yKJLhzghTKI5uAh0r8dw/biwGskxLSsXOH8MMJ/7biQP+rHmSqQkyZpqQ
         5iZifwmRgksbK0KJglEuDw+Em5v50Akfq2X/p47Lf9k17mab3RBzp7DbY2ZcIaLqtjny
         jtpCq6MU6Uwd7Ppz+pJZOb/Xm+pAsK6xs3VTo=
Date: Wed, 20 Aug 2008 09:31:57 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: evdev.c(EVIOCGBIT): Suspicious buffer size 511,
Message-ID: <20080820092806.ZZRA012@mailhub.coreip.homeip.net>
References: <dd18b0c30808172310u7cf7836ai15e19485908ae0ce@mail.gmail.com> <20080820000040.55015b48.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820000040.55015b48.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 12:00:40AM -0700, Andrew Morton wrote:
> On Sun, 17 Aug 2008 23:10:54 -0700 "Justin Mattock" <justinmattock@gmail.com> wrote:
> 
> > I'm noticing:
> > evdev.c(EVIOCGBIT): Suspicious buffer size 511, limiting output to 64
> > bytes. See http://userweb.kernel.org/~dtor/eviocgbit-bug.html
> > with rc-3 not with rc2.
> > Did the patch to synaptics, seems
> > my xorg is not reading /usr/X11R6/lib/modules/input/synaptics_drv.o
> > only /usr/lib/xorg/modules/input/synaptics_drv.so
> > is there any easy fix, or do I have to recompile xorg?
> > regards;
> > 
> 
> (cc's added)
> 

You can just copy the updated file manually into
/usr/lib/xorg/modules/input/.

I tried rebuilding synaptics from here:

git://anongit.freedesktop.org/git/xorg/driver/xf86-input-synaptics

but unfortunately it fails with some automake crap that I don't have
time to trace through at the moment.

-- 
Dmitry
