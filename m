Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbYDIUjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbYDIUjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYDIUjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:39:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:44695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbYDIUjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:39:39 -0400
Date: Wed, 9 Apr 2008 13:39:09 -0700
From: Greg KH <gregkh@suse.de>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Message-ID: <20080409203909.GA17183@suse.de>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com> <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 07:51:23PM +0200, Bert Wesarg wrote:
> On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
> >   * Cleanup usages of cpumask_scprintf in the following files and add
> >     another interface to use cpulist_scnprintf where appropriate.
> 
> On Mon, Apr 7, 2008 at 8:22 PM, Mike Travis <travis@sgi.com> wrote:
> >  Part of the change is readability, but also looking towards the future
> >  of 16k/64k/??? # of cpus, the straight mask approach will overflow the
> >  PAGE_SIZE buffer provided (though some pathological cases will overflow
> >  the range method as well.)  So we'll need some advancement in the format
> >  of the printout.
> 
> Btw, I think you can now push for a deprecation of the 'old' mask
> attributes, with the justification you have given above. The other
> possibility is to change sysfs to provide bigger attribute buffers
> (CCed Greg for this).

Huh?

sysfs is "one value per file", if you are getting close to PAGE_SIZE in
any sysfs file, then you are doing something very wrong.

What sysfs file currently is trying to output data this big?

thanks,

greg k-h
