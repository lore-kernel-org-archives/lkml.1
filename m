Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZBTSW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZBTSW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZBTSWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:22:46 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:23518
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753971AbZBTSWp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:22:45 -0500
X-BigFish: VPS-25(zz1432R98dR1805M936fKzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KFDN1F-02-J8T-01
Date: Fri, 20 Feb 2009 19:22:12 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
	processor
Message-ID: <20090220182212.GH4834@alberich.amd.com>
References: <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <20090220115357.GE4834@alberich.amd.com> <499ECF87.2070204@cfl.rr.com> <20090220160843.GF4834@alberich.amd.com> <20090220163844.GG4834@alberich.amd.com> <499EE3BA.7070105@cfl.rr.com> <499EEB0F.8010201@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <499EEB0F.8010201@cfl.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Feb 2009 18:22:33.0615 (UTC) FILETIME=[32EF51F0:01C99388]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 12:40:31PM -0500, Mark Hounschell wrote:

> ACPI: HPET id: 0x10b9a201 base: 0xfed00000

  <snip>

> hpet: hpet_enable(834):
> hpet: ID: 43538301, PERIOD: 429b17e


This means that your BIOS could be bogus.
Obviously ACPI HPET table contains different information about
your HPET configuration than the HPET registers are showing.

This means that other chipset configuration (e.g. ACPI tables) could
also be wrong.

To confirm this please provide us output of

# xxd /sys/firmware/acpi/tables/HPET


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


