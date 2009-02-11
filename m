Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZBKBLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZBKBLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZBKBLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:11:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:47019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZBKBLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:11:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,188,1233561600"; 
   d="scan'208";a="429950108"
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
From: yakui_zhao <yakui.zhao@intel.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
In-Reply-To: <71cd59b00902100806s44f40812p441fae0b157cdb9c@mail.gmail.com>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain>
	 <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk>
	 <20090209234911.GB862@elte.hu>
	 <5030E21460%linux@youmustbejoking.demon.co.uk>
	 <20090210150431.GA26798@srcf.ucam.org>
	 <5030E7CFF4%linux@youmustbejoking.demon.co.uk>
	 <20090210154533.GA27596@srcf.ucam.org>
	 <71cd59b00902100806s44f40812p441fae0b157cdb9c@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Wed, 11 Feb 2009 09:23:20 +0800
Message-Id: <1234315400.3706.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 00:06 +0800, Corentin Chary wrote:
> On Tue, Feb 10, 2009 at 4:45 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Tue, Feb 10, 2009 at 03:15:21PM +0000, Darren Salt wrote:
> >
> >> As things stand, this is likely to be a problem for anybody using lenny on
> >> Eee hardware and upgrading (on their own) to 2.6.29, given that that
> >> workaround is present in eeepc-acpi-scripts in lenny.
> >>
> >> Anyway, removing that option fixes the problem.
> >
> > Ok. I'll look into ensuring that these don't collide, but fundamentally
> > the problem here is distributions using broken options rather than
> > fixing the problem properly in the first place.
> >
> >> > BIOS bug. There's an explicit delay in the eee bios for some reason, and
> >> > I haven't found any straightforward way to avoid it.
> >>
> >> BIOS bug or no, the fact remains that this is (AFAICS) a regression.
> >
> > You don't get properly working hotkeys otherwise, to the best of my
> > recollection. There's an entry on the kernel bugzilla about this
> > somewhere.
> > --
> > Matthew Garrett | mjg59@srcf.ucam.org
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12243
> If I understand things correctly, this was already the case before,
> but the kernel boot was slower, so we could'nt see that.
> If it's not the case, someone with a 901 should try bisecting (I only
> have a 701).
I have an Asus EEEPC901. And it will take about 1 second to execute the
ACPI INIT object, which is defined in BIOS.
    From the ACPI AML code it seems that there exist some explicit
delays. But we have nothing to avoid it.  
> 
> 

