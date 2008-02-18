Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbYBRKmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbYBRKmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYBRKmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:42:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:21033 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYBRKmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:42:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hn0iG5VcNSJh+EDhlfYcITt8WmnkkDvqVQtaYDyl9rdBWUOyaizXoXiO34X5aNcJw/RqIX4G2LhJ4xI+z/sBwYzk9iU8wXrZXNd0oTbJIlbzmYrZeCvYsqWA1fdiSF1P5yqowewPKic175veVNIa1Fk8ZTfy1uSQto07lbAOve8=
Message-ID: <b6fcc0a0802180242w6464b0dbk986f640e828030b3@mail.gmail.com>
Date: Mon, 18 Feb 2008 13:42:00 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Tilman Schmidt" <tilman@imap.cc>, "Greg KH" <gregkh@suse.de>
In-Reply-To: <47B956EE.7020804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802172304.00322.rjw@sisk.pl> <47B9473D.20508@gmail.com>
	 <b6fcc0a0802180143u65120b97wa87d59eb17f37ed2@mail.gmail.com>
	 <20080218094939.GB31970@elte.hu> <47B956EE.7020804@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/08, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 02/18/2008 10:49 AM, Ingo Molnar wrote:
> > * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >
> >> Why on earth do we have CONFIG_SYSFS_DEPRECATED at all if the only
> >> sane choice for someone who tests new kernels is to always turn it on?
> >
> > seconded ...
> >
> > it's insane how inconvenient certain storage systems are to use, and
> > people get turned away with NOATBUG. ITISABUG every time user-space
> > breaks or the user has to do _anything_ to get the box working as it
> > should.
>
> No, user needn't to do anything. Just turn that default y option really to y

Suprise, surprise, make oldconfig won't tell you anything about defaults
because you already turned it off moons ago.

> (yes, you are right, the help text of this option is misleading...).

Agree, reference to 2006 is particularly pathetic, given that breakage
happened on recent fedora (sorry, box was reinstalled since then,
I can't recall which fedora exactly).

> It's like you turn off old acpi events option and scream that you acpi daemon
> doesn't work  for instance.
> There are many instances of this behaviour in the kernel.

Indeed, but don't mix types of breakage, please.
You can turn off ACPI or CPU_FREQ or SMP and forget.
You can't turn off SYSFS_DEPRECATED and forget.

> And yes, many people don't need that option tuyrned on --

Wish them luck.

/me goes on thinking about cpufreqfs to eventually turn off SYSFS
completely.
