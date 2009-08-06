Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbZHFKXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbZHFKXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZHFKW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:22:59 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39825 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZHFKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:22:58 -0400
Date: Thu, 6 Aug 2009 12:22:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Douglas Leeder <douglas.leeder@sophos.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090806102252.GG31370@elf.ucw.cz>
References: <1248466429.3567.82.camel@localhost> <20090805020534.GB1354@ucw.cz> <200908051746.17903.tvrtko.ursulin@sophos.com> <20090806101059.GD31370@elf.ucw.cz> <4A7AAE89.20205@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7AAE89.20205@sophos.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-08-06 11:20:57, Douglas Leeder wrote:
> Pavel Machek wrote:
> > On Wed 2009-08-05 17:46:16, Tvrtko Ursulin wrote:
> >> On Wednesday 05 August 2009 03:05:34 Pavel Machek wrote:
> 
> >> Just to make sure you haven't missed this - it is not that they have to 
> >> complete the whole operation before the timeout period (since you mention 
> >> realtime/mlock I suspect this is what you think?), but _during_ the operation 
> >> they have to show that they are active by sending something like keep alive 
> >> messages.
> >>
> >> Or you are worried about failing to meet even that on a loaded system? There 
> >> has to be something like this otherwise hung userspace client would kill the 
> >> whole system.
> > 
> > Of course, I'm worried about failing to meet this on loaded
> > system. And the fact that I _have_ to worry about that means that
> > interface is ugly/broken.
> 
> You mean that in 5 seconds, you won't have any point when you can tell
> the kernel, "I'm still working"?

Yes. Try make -j on your machine one day.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
