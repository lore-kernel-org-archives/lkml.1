Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZJFIVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZJFIVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZJFIVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:21:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53685 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZJFIVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:21:38 -0400
Date: Tue, 6 Oct 2009 10:12:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Wang, Shane" <shane.wang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Subject: Re: [GIT PULL] x86/txt for v2.6.32
Message-ID: <20091006081258.GB1469@ucw.cz>
References: <20090928211745.GA2119@elf.ucw.cz> <4AC1AA61.8070408@intel.com> <20090929171318.GC14405@elf.ucw.cz> <20090929191951.18315e94@infradead.org> <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com> <20090930065448.GB11652@elf.ucw.cz> <037F493892196B458CD3E193E8EBAD4F01ED9FE6E3@pdsmsx502.ccr.corp.intel.com> <20091003201959.GA16047@elf.ucw.cz> <20091003203619.GA27182@khazad-dum.debian.net> <ada4oqgp5qx.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada4oqgp5qx.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-10-03 13:44:22, Roland Dreier wrote:
> 
>  > > > So I modify the RAM content so that BIOS does not think measured
>  > > > environment existed before suspend?
> 
>  > And it is ridiculously easy to pull off, too:
>  > http://www.engadget.com/2008/02/21/cold-boot-disk-encryption-attack-is-shockingly-effective/
>  > 
>  > Shows the attack being used to read sensitive keys, but you can use it also
>  > to *modify* system running state (it will be more difficult, as you need to
>  > remove and replace the RAM while on S3 instead of S5, but it should be
>  > doable by someone who knows what he is doing).
> 
> I believe the whole point of this TXT / S3 handling is that the resume
> from S3 will then be able to detect that the contents of RAM have been
> modified while the system was asleep.

...and you are able to read out any keys, etc. Maybe that's expected &
ok, but Doc*/intel_txt.txt does not actually tell me what it protects
against and is pretty much useless... making patches impossible to
review.

So... what does txt protect?

Data integrity only?

Data privacy, too?

Who is it designed to protect against?

Remote attacker?

Local user trying to subvert it?

...and has soldering iron he's willing to use?

...and has soldering iron, osciloscope and PCI analyzer he's willing to use?

> TXT simply produces a reasonably trustworthy measurement of system
> state.  If you modify RAM while the system is asleep, then you will not
> be able to produce a measurement showing an unmodified system state.

Well, actually I see some auditing to be done in proposed patches.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
