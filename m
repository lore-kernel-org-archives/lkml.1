Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZCPI1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZCPI1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZCPI1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:27:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42103 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZCPI1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:27:08 -0400
Date: Mon, 16 Mar 2009 09:29:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>,
       Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Message-ID: <20090316082952.GA1963@elf.ucw.cz>
References: <1227454026.7262.59.camel@localhost> <20081123180409.GB7731@ucw.cz> <20081202161520.GA18252@srcf.ucam.org> <20081202201442.GA1504@ucw.cz> <alpine.LFD.2.00.0903160020250.30317@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903160020250.30317@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-03-16 00:24:18, Len Brown wrote:
> 
> On Tue, 2 Dec 2008, Pavel Machek wrote:
> 
> > On Tue 2008-12-02 16:15:21, Matthew Garrett wrote:
> > > On Sun, Nov 23, 2008 at 07:04:09PM +0100, Pavel Machek wrote:
> > > 
> > > > Is this really needed? Could we simply talk to the cpu directly,
> > > > without help of ACPI?
> > > 
> > > No. The ACPI write ends up talking to the embedded controller and some 
> > > io ports.
> > 
> > Oops... I always knew that eee-s are broken by design (reporting
> > battery percent as mWh, etc...) but I did not realize how bad it
> > is. (ACPI has perfectly standard cpu frequency scaling interface, even
> > if it is not used too often these days....)
> 
> Huh?
> 
> What cpufreq driver is deployed more broadly than acpi-cpufreq?
> AFAIK, Linux uses it on nearly every ACPI compliant Intel-based
> system that has frequency scaling.

Problem seems to be that eee uses custom ACPI methods
(switch_to_fast_clock(0/1)-like), not anything acpi-cpufreq could
drive... Broken by design :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
