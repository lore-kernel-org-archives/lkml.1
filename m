Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317Ab0AMODZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0AMODZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960Ab0AMODY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:03:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34383 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0AMODX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:03:23 -0500
Date: Wed, 13 Jan 2010 14:50:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, len.brown@intel.com,
       ibm-acpi@hmh.eng.br, kernel list <linux-kernel@vger.kernel.org>,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer
	shows all the temperatures on thinkpad x60
Message-ID: <20100113135039.GA1848@ucw.cz>
References: <20091227215722.GN11737@elf.ucw.cz> <20091228130138.GA19362@khazad-dum.debian.net> <20100107214904.GB25538@elf.ucw.cz> <20100109134409.GA936@khazad-dum.debian.net> <20100109135919.GC936@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100109135919.GC936@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Well, I'm not sure its completely fixed. I got this in my syslog:
> > > 
> > > thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
> > > extremely hot!
> > > thinkpad_acpi: temperatures (Celsius): 95 47 N/A 89 47 N/A 41 N/A 51
> > > 61 N/A N/A N/A N/A N/A N/A
> > 
> > And the extremely hot sensor is that 89°C, which is the GPU I think (varies
> > from thinkpad to thinkpad).  That is not normal, and I'd say it needs
> > repair, probably a badly seated heatsink or failed thermal interface
> > compound.

Well, I'd prefer not to open it unless absolutely neccessary. It is my
primary machine. 

> Hmm... come to think of it, the CPU is also quite hot (95°C), and it usually
> shares the heatsink system with the GPU/north bridge, so the problem might
> be on the CPU side of things.
> 
> While it can easily be a hardware problem in the heatsink, we could also
> have a screwed up ACPI thermal control in our hands once again (either
> kernel bug, or bogus ACPI firmware in the laptop).

Well, galeon (web browser) started misbehaving -- eating 100% cpu --
lately, so maybe that's it.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
