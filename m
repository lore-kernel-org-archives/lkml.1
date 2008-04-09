Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYDIVQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYDIVQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYDIVP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:15:59 -0400
Received: from ns1.suse.de ([195.135.220.2]:60364 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbYDIVP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:15:58 -0400
Date: Wed, 9 Apr 2008 14:14:11 -0700
From: Greg KH <gregkh@suse.de>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Message-ID: <20080409211411.GA11120@suse.de>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com> <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com> <20080409203909.GA17183@suse.de> <36ca99e90804091352g4910fc6cr2d23279324e12cf1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ca99e90804091352g4910fc6cr2d23279324e12cf1@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 10:52:58PM +0200, Bert Wesarg wrote:
> On Wed, Apr 9, 2008 at 10:39 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > On Wed, Apr 09, 2008 at 07:51:23PM +0200, Bert Wesarg wrote:
> >  > On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
> >  > >   * Cleanup usages of cpumask_scprintf in the following files and add
> >  > >     another interface to use cpulist_scnprintf where appropriate.
> >  >
> >  > On Mon, Apr 7, 2008 at 8:22 PM, Mike Travis <travis@sgi.com> wrote:
> >  > >  Part of the change is readability, but also looking towards the future
> >  > >  of 16k/64k/??? # of cpus, the straight mask approach will overflow the
> >  > >  PAGE_SIZE buffer provided (though some pathological cases will overflow
> >  > >  the range method as well.)  So we'll need some advancement in the format
> >  > >  of the printout.
> >  >
> >  > Btw, I think you can now push for a deprecation of the 'old' mask
> >  > attributes, with the justification you have given above. The other
> >  > possibility is to change sysfs to provide bigger attribute buffers
> >  > (CCed Greg for this).
> >
> >  Huh?
> >
> >  sysfs is "one value per file", if you are getting close to PAGE_SIZE in
> >  any sysfs file, then you are doing something very wrong.
> >
> >  What sysfs file currently is trying to output data this big?
> Currently none. But if NR_CPUS >= 16K and PAGE_SIZE == 4K, than any
> file with an cpumask_scnprintf().

Do we have such sysfs files today?

thanks,

greg k-h
