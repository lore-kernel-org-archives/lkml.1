Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbYIMQ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbYIMQ5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 12:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYIMQ5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 12:57:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1209 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751982AbYIMQ5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 12:57:02 -0400
Date: Sat, 13 Sep 2008 18:56:49 +0200
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andi Kleen <ak@linux.intel.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: Re: [patch 00/42] 2.6.26-stable review
Message-ID: <20080913165649.GA8319@ucw.cz>
References: <20080903172447.GA7731@suse.de> <20080904023905.GA1071@khazad-dum.debian.net> <20080912142251.GA6028@ucw.cz> <48CA8CAA.1000004@linux.intel.com> <20080912194634.GA32638@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912194634.GA32638@khazad-dum.debian.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-09-12 16:46:35, Henrique de Moraes Holschuh wrote:
> On Fri, 12 Sep 2008, Andi Kleen wrote:
> > Pavel Machek wrote:
> >> On Wed 2008-09-03 23:39:05, Henrique de Moraes Holschuh wrote:
> >>> What about this one:
> >>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f497bcc695fb828da023d74ad3c966b1e58ad21
> >>>
> >>> "ACPI: Fix thermal shutdowns" ?
> >>>
> >>> It should have been submitted to stable@k.o well before 2.6.26.3, but it
> >>> wasn't for some stupid reason.  Then some of us noticed it was missing in
> >>> 2.6.26.3, and gave everyone a head's up, but it was too late for 2.6.26.3.
> >>>
> >>> And now it also apparently failed to make it to 2.6.26.4?
> >>>
> >>> As far as I recall, without this patch, all X6* ThinkPads that are not in
> >>> absolute top-notch thermal condition heat up until they are forced to
> >>> shutdown due to overtemperature (thus, slowly further damaging hardware that
> >>> is not in good shape to begin with).
> >>>
> >>> Greg, is there any way to include the above patch for 2.6.26.4?
> >>
> >>
> >>
> >> Agreed. This patch makes thinkpads unusable... and it was actually
> >> included in 2.6.26.2...
> >
> > I guess the best/safest course right now is to just revert in stable.
> 
> I am not so sure.  You can fix it with an one-line patch that is in mainline
> since before -rc4 and is known to work, or you can drop the _PPC fixes
> entirely.  But I presume those fixes were NOT sent to stable gratuitously in
> the first place, so it seems safer to just fix them instead of reverting
> them.

Agreed. Bugfix was tested and is pretty obvious.

...but complete revert is still better than keeping 'thinpkad-cooking'
bug.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
