Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbYHSLAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbYHSLAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYHSLAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:00:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35844 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbYHSLAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:00:32 -0400
Date: Tue, 19 Aug 2008 12:41:24 +0200
From: Pavel Machek <pavel@suse.cz>
To: Rik van Riel <riel@redhat.com>
Cc: david@lang.hm, Eric Paris <eparis@redhat.com>,
       Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
Message-ID: <20080819104124.GA29788@elf.ucw.cz>
References: <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <1218769209.16613.31.camel@localhost.localdomain> <20080817221258.GC21112@atrey.karlin.mff.cuni.cz> <alpine.DEB.1.10.0808171542160.12859@asgard.lang.hm> <20080817225844.GE21112@atrey.karlin.mff.cuni.cz> <20080817200739.23496033@riellaptop.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817200739.23496033@riellaptop.surriel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-08-17 20:07:39, Rik van Riel wrote:
> On Mon, 18 Aug 2008 00:58:44 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > Rather than modify all the applications using mmap (you can't tell if
> > the other side is going to use it for shared memory... right?), we
> > could simply modify all the Windows-facing applications using mmap.
> 
> If web browsers, office suites and mail clients on Windows
> have certain kinds of vulnerabilities, it is safe to assume
> that the same programs on Linux will have similar problems.
> 
> Can we please get rid of the idea that "Windows facing" is
> where the whole malware problem is?
> 
> As for how to solve it - lets try to come up with a solution
> that is reasonably high performance and can be used for more
> than just malware scanning.  

Don't mix exploits with viruses -- they are different.

Exploit is where application does something very unexpected due to a
bug.

Virus is where machine works correctly, but user does something
stupid.

For exploits, randomization + patching + compartments seem like a
solution. We should be working on "how to confine openoffice.org so
that it can't do much damage" instead of "how to detect .doc documents
that makes openoffice.org do something unexpected".

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
