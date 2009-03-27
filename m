Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZC0DBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZC0DBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZC0DBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:01:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50253 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZC0DBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:01:32 -0400
Date: Fri, 27 Mar 2009 03:01:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327030118.GA16343@srcf.ucam.org>
References: <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326182519.d576d703.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 06:25:19PM -0700, Andrew Morton wrote:
> On Thu, 26 Mar 2009 18:03:15 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > You state that without any amount of data to back it up, as if it was some 
> > kind of truism. It's not.
> 
> I've seen you repeatedly fiddle the in-kernel defaults based on
> in-field experience.  That could just as easily have been done in
> initscripts by distros, and much more effectively because it doesn't
> need a new kernel.  That's data.

If there's a sensible default then it belongs in the kernel. Forcing 
these decisions out to userspace just means that every distribution 
needs to work out what these settings are, and the evidence we've seen 
when they attempt to do this is that we end up with things like broken 
cpufreq parameters because these are difficult problems. The simple 
reality is that almost every single distribution lacks developers with 
sufficient understanding of the problem to make the correct choice.

The typical distribution lifecycle is significantly longer than a kernel 
release cycle. It's massively easier for people to pull updated kernels.

> Why does everyone just sit around waiting for the kernel to put a new
> value into two magic numbers which userspace scripts could have set?

If the distribution can set a globally correct value then that globally 
correct value should be there in the first place!

> My /etc/rc.local has been tweaking dirty_ratio, dirty_background_ratio
> and swappiness for many years.  I guess I'm just incredibly advanced.

And how have you got these values pushed into other distributions? Is 
your rc.local available anywhere?

Linus is absolutely right here. Pushing these decisions out to userspace 
means duplicated work in the best case - in the worst case it means most 
users end up with the wrong value.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
