Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbXDYNpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbXDYNpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXDYNpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:45:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:45862 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXDYNpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G/p1+TAueLMX6XFdXTefKRgB5U5azFlREv2AATj2GKH43xNYFFHHjZdwR0Z+5/+kG9xuLq8jEo7sBqsP+szxvUvtfxsM6CraG8kbq3+i1kYCrSYnhXH467kdbhx7pI7Zy0fUfEavDzDOyAdcA5pn8ntSaLxR4T0wFl8oJ7SqyoA=
Message-ID: <b6a2187b0704250645t62a0d8u20f1f43df6feaea@mail.gmail.com>
Date: Wed, 25 Apr 2007 21:45:44 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Guilherme Schroeder" <guilherme@centralinf.com.br>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "John Stultz" <johnstul@us.ibm.com>,
       "Mikael Pettersson" <mikpe@it.uu.se>, ak@suse.de, discuss@x86-64.org,
       pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       "Dave Jones" <davej@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       "James Simmons" <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "Dmitry Torokhov" <dtor@insightbb.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20070425114317.GA32153@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	 <20070423214909.GD3468@stusta.de>
	 <20070425040605.6d6b4a82.akpm@linux-foundation.org>
	 <20070425114317.GA32153@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > > Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
> > > References : http://lkml.org/lkml/2007/3/25/217
> > > Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> > > Status     : unknown
> >
> > That's still rather a lot of bustage from the timekeeping changes.  Is
> > anything really happening here or have we all given up?
>
> Jeff: does that suspend-to-disk hang problem also happen if you use
> hpet=disable?

Yes, it is still broken with HPET disabled.

I've reported that if I press some keys, suspend will complete
successfully, otherwise, it'll just hang before the "percentage" comes
on.

Thanks,
Jeff.
