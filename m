Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbXHBV5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbXHBV5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbXHBV5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:57:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:50499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759805AbXHBV52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:57:28 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Adrian =?utf-8?q?Schr=C3=B6ter?= <adrian@suse.de>
Subject: Re: 2.6.22 regression: thermal trip points
Date: Thu, 2 Aug 2007 17:56:32 -0400
User-Agent: KMail/1.9.5
Cc: trenn@suse.de, Knut Petersen <Knut_Petersen@t-online.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       pavel@ucw.cz, mjg59@srcf.ucam.org, "Zhang, Rui" <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, linux-acpi@vger.kernel.org
References: <46B1988C.3090302@t-online.de> <1186047747.18821.450.camel@queen.suse.de> <200708021145.09377.adrian@suse.de>
In-Reply-To: <200708021145.09377.adrian@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708021756.32802.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007 05:45, Adrian Schröter wrote:
> On Thursday 02 August 2007 11:42:27 wrote Thomas Renninger:
> > On Thu, 2007-08-02 at 10:40 +0200, Knut Petersen wrote:
> > > Hi everybody!
> > >
> > > Kernel 2.6.22 decreases performance by about 50% on my system.
> > > No, I do not like that. The reason is a broken BIOS, granted, but there
> > > was a perfect workaround in the kernel that has been dropped.
> > >
> > > mainboard: AOpen i915GMm-hfs, AWARD BIOS
> > > cpu: Pentium-M 750 (0.8 to 1.86 MHz)
> > > openSuSE 10.2 with kernel 2.6.22.1
> >
> > Is this a DELL laptop that gets throttled by 75% to throttling state 6
> > if 60 degrees are exceeded?
> > Adrian has such a machine..., no idea what is going on with that one,
> > but only workaround to get any use out of this machine is to override at
> > least the passive trip point.
> 
> JFYI, there are plenty of these systems around, it was one out of four 
> standard Novell modells. I am mabye just the first one who uses Factory on 
> it, but expect more bugreports when 10.3 gets released ...

That's very good news, Adrian.  In the past all we had to go on
was the memory of a machine that died several years ago.
But if you've got a live failure, that is really valuable.

Please go here
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
and submit a new sighting vs. Power-Thermal
and attach the output from acpidump, cat /proc/acpi/thermal_zone/*/*
and assign it to len.brown@intel.com

thanks,
-Len
