Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYHQWPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYHQWPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYHQWOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:14:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56643 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYHQWOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:14:55 -0400
Date: Mon, 18 Aug 2008 00:14:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: david@lang.hm
Cc: Eric Paris <eparis@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Rik van Riel <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to	alinuxinterfaceforon access scanning
Message-ID: <20080817221453.GD21112@atrey.karlin.mff.cuni.cz>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain> <alpine.DEB.1.10.0808142212430.12859@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808142212430.12859@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Aug 2008, Eric Paris wrote:
> 
> >>But Pavel is raising a good question.  In Eric's proposed threat
> >>model, he claimed the only thing that he was trying to solve was
> >>"scanning".  Just file scanning.  That implies no root privileges, but
> >>it also implied that he wasn't worried about malware running with user
> >>privileges, either.  Presumbly, that would be caught and stopped by
> >>the file scanner before the malware had a chance to run; that is the
> >>execve(2) system call would also be blocked until the executable was
> >>scanned.
> >>
> >>So if that is the threat model, then the only thing libmalware.so
> >>doesn't solve is knfsd access, and it should be evaluated on that
> >>basis.  If the threat model *does* include malware which is **not**
> >>caught by the AV scanner, and is running with user privileges, then
> >>there are a whole host of other attacks that we have to worry about.
> >>So let's be real clear, up front, what the threat model is, and avoid
> >>changing the model around to rule out solutions that don't fit the
> >>initially preconceived one.  That's how you get to the TSA
> >>confiscating water bottles in airport security lines.
> >
> >No, I'm not claiming to protect against running processes.  I'll leave
> >that for SELinux.
> >
> >I haven't seen this supposed libmalware.so so take anything I say with a
> >grain of sand.  But I take it that the solutions to the problems are
> >'don't do that.'
> 
> libmalware.so is shorthand for 'have a userspace library do the scanning 
> and handle the open'

(snip). Agreed, you explained it better than I would.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
