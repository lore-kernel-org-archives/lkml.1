Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660Ab0ANU6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0ANU6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239Ab0ANU6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:58:39 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:57343 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0ANU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:58:38 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable LVDS downclock by default
From: Peter Clifton <pcjc2@cam.ac.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Nick Bowler <nbowler@elliptictech.com>, airlied@linux.ie,
       intel-gfx@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100114124802.025bbcae@jbarnes-piketon>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	 <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
	 <20100113133357.67f9df6d@jbarnes-piketon> <4B4E403C.1050509@cs.helsinki.fi>
	 <20100113165530.2a7e7645@jbarnes-piketon> <4B4F6D5F.10008@cs.helsinki.fi>
	 <20100114193118.GA1203@emergent.ellipticsemi.com>
	 <84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
	 <20100114202803.GA1749@emergent.ellipticsemi.com>
	 <20100114124802.025bbcae@jbarnes-piketon>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 14 Jan 2010 20:58:31 +0000
Message-ID: <1263502711.16937.5.camel@pcjc2lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 12:48 -0800, Jesse Barnes wrote:
> Many platform support this feature, and it can provide significant
> power savings when the reduced refresh rate is low.  However, on some
> platforms a secondary (reduced) timing is provided but not actually
> supported by the hardware.  This results in undesirable flicker at
> runtime.
> 
> So disable the feature by default, but allow users to opt-in to the
> reduced clock behavior with a new module parameter, lvds_downclock,
> that can be set to 1 to enable the feature.

Would it not be a better idea to turn this feature on by default, then
use quirks to disable it on the afflicted borken machines?

Requiring special module parameters to enable the feature, almost
guarantees that no normal end-users will end up benefiting from the
feature. Many of whom will have bought machines which don't have screwey
BIOS implementations.

I think (on a general note) that vendors supplying defective BIOSen or
config should be "named and shamed" in quirk tables - so eventually they
will get something done about the problems for future models.



