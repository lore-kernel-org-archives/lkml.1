Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbXLBV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbXLBV4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXLBVzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:55:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44928 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750717AbXLBVzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:55:51 -0500
Date: Sun, 2 Dec 2007 22:56:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: tvrtko.ursulin@sophos.com, Andi Kleen <andi@firstfloor.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071202215634.GB2438@elf.ucw.cz>
References: <p738x4i9nyd.fsf@crumb.suse.de> <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com> <20071201084332.GB4446@ucw.cz> <17957.1196624688@turing-police.cc.vt.edu> <20071202202240.GB1625@elf.ucw.cz> <23463.1196629795@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23463.1196629795@turing-police.cc.vt.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-02 16:09:55, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 02 Dec 2007 21:22:40 +0100, Pavel Machek said:
> > Well, if you only want to detect viruses _sometimes_, you can just
> > LD_PRELOAD your scanner.
> 
> And for some use cases, that probably *is* the best answer..

I'd say so.

> > I guess the A/V people should describe what they are trying to do, as
> > in
> > 
> > "forbidden sequences of bits should never hit disk" or "forbidden
> > sequences of bits should be never read from disk"  or something...
> 
> We probably want to hear related usages as well - what *besides* A/V would be
> interested? Indexing services?  

Well... I'd really like to know what A/V people are trying to do.

Indexing services are really different, and doable with recursive
m-time Jan is preparing... 

> Software that tries to limit the
> distribution
> of sensitive info off the machine - for instance, imagine a rule that said
> "Data that comes from a file that contains SSNs or the string 'Corporate
> Secret' data isn't allowed to leave the computer" and a Perl-like 'taint'
> concept.  I'm not saying its *doable*, but it's certainly a goal that somebody
> would like to achieve...

That sounds like a task for SELinux, no?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
