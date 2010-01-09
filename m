Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645Ab0AIN7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0AIN7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634Ab0AIN7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:59:31 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34315 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410Ab0AIN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:59:22 -0500
X-Sasl-enc: Ai9nSZVAHHsB1+IU+sQ1UlFwVCZTweU4qJpLeJMMGdvc 1263045561
Date: Sat, 9 Jan 2010 11:59:19 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, len.brown@intel.com,
       ibm-acpi@hmh.eng.br, kernel list <linux-kernel@vger.kernel.org>,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer
 shows all the temperatures on thinkpad x60
Message-ID: <20100109135919.GC936@khazad-dum.debian.net>
References: <20091227215722.GN11737@elf.ucw.cz>
 <20091228130138.GA19362@khazad-dum.debian.net>
 <20100107214904.GB25538@elf.ucw.cz>
 <20100109134409.GA936@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100109134409.GA936@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Jan 2010, Henrique de Moraes Holschuh wrote:
> On Thu, 07 Jan 2010, Pavel Machek wrote:
> > > Please apply the latest stack of patches (sent them to acpi-test
> > > yesterday).
> > > 
> > > It is failing to register the ALSA mixer for some reason, and due
> > > to a bug, it is not loading the module at all.  I will look at the reason it
> > > is failing to register the ALSA mixer soon.  Meanwhile, the patches I sent
> > > to Len make sure the module can still load sucessfully.
> > 
> > Well, I'm not sure its completely fixed. I got this in my syslog:
> > 
> > thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
> > extremely hot!
> > thinkpad_acpi: temperatures (Celsius): 95 47 N/A 89 47 N/A 41 N/A 51
> > 61 N/A N/A N/A N/A N/A N/A
> 
> And the extremely hot sensor is that 89°C, which is the GPU I think (varies
> from thinkpad to thinkpad).  That is not normal, and I'd say it needs
> repair, probably a badly seated heatsink or failed thermal interface
> compound.

Hmm... come to think of it, the CPU is also quite hot (95°C), and it usually
shares the heatsink system with the GPU/north bridge, so the problem might
be on the CPU side of things.

While it can easily be a hardware problem in the heatsink, we could also
have a screwed up ACPI thermal control in our hands once again (either
kernel bug, or bogus ACPI firmware in the laptop).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
