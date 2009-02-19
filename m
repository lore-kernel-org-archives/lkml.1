Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbZBSPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbZBSPez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZBSPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:34:46 -0500
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:23597
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753311AbZBSPep convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:34:45 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 10:34:45 EST
X-BigFish: VPS-29(zz1432R98dR1805M936fK103dKzzzzz32i6bh6di62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KFBJWE-01-82L-01
Date: Thu, 19 Feb 2009 16:19:30 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090219151930.GB7613@aftab>
References: <20090209141841.GA31643@aftab> <49904BED.7090208@cfl.rr.com> <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <499D77D8.509@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <499D77D8.509@cfl.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 19 Feb 2009 15:19:30.0478 (UTC) FILETIME=[760FDCE0:01C992A5]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 10:16:40AM -0500, Mark Hounschell wrote:
> Andreas Herrmann wrote:
> > Hi Mark,
> > 
> > Can you please provide us output of lspci -vvxxx.
> > (Please run this as root.)
> > 
> > Furthermore you can try booting your 1000HZ kernel
> > with following kernel command lines:
> > 
> > (1) acpi_skip_timer_override apic=debug
> > (2) nohpet apic=debug
> > (3) acpi_skip_timer_override nohpet apic=debug
> > 
> > and send us all dmesg output.
> > 
> > 
> > Thanks!
> > 
> > Andreas
> > 
> 
> Should I leave the leave the immediate return I put in the check_hlt routine or
> set it back to normal first?

Yes, please. Remove all patches/changes you've applied.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

