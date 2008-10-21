Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYJUShA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYJUShA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYJUSgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:36:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56582 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752507AbYJUSgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:36:50 -0400
Date: Tue, 21 Oct 2008 20:36:34 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
Message-ID: <20081021183634.GA1475@ucw.cz>
References: <1224552902.2640.88.camel@alok-dev1> <20081021095002.GA5880@atrey.karlin.mff.cuni.cz> <1224607688.6161.25.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224607688.6161.25.camel@alok-dev1>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-21 09:48:08, Alok Kataria wrote:
> On Tue, 2008-10-21 at 02:50 -0700, Pavel Machek wrote:
> > > Hi,
> > >
> > > This patch set makes some changes to the TSC code, so that it is always
> > > used as the default clocksource when running under VMware.
> > > The first 2 patches do the ground work of adding code to detect if we
> > > are running under VMware.
> > > The third patch adds a tsc_reliable flag which tells us that TSC is
> > > reliable on this system, so that we can skip some tests which can
> > > potentially mark TSC as unstable. Details under individual patch
> > > headers.
> > 
> > How do you _know_ TSC is stable under VMWare? 
> 
> Since we implement it that way :)
> The hypervisor takes care of providing a constant rate TSC to the guest
> on such systems which have variable frequency.

Aha, so tsc accesses trap to VMWare? Ok, then...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
