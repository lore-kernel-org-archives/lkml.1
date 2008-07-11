Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbYGKM0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbYGKM0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYGKM03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:26:29 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:46334 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbYGKM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:26:29 -0400
X-BigFish: VPS-21(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3UD7S-01-3BA-01
Date: Fri, 11 Jul 2008 14:26:16 +0200
From: Robert Richter <robert.richter@amd.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: Removing pci-y in Makefile
Message-ID: <20080711122616.GZ7963@erda.amd.com>
References: <1215771239-27725-1-git-send-email-robert.richter@amd.com> <20080711120405.GA23423@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080711120405.GA23423@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jul 2008 12:26:17.0956 (UTC) FILETIME=[51849A40:01C8E351]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.08 14:04:05, Sam Ravnborg wrote:
> On Fri, Jul 11, 2008 at 12:13:59PM +0200, Robert Richter wrote:
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> >  arch/x86/pci/Makefile |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
> > index e515e8d..28451f4 100644
> > --- a/arch/x86/pci/Makefile
> > +++ b/arch/x86/pci/Makefile
> > @@ -5,13 +5,13 @@ obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_$(BITS).o direct.o mmconfig-shared.o
> >  obj-$(CONFIG_PCI_DIRECT)	+= direct.o
> >  obj-$(CONFIG_PCI_OLPC)		+= olpc.o
> >  
> > -pci-y				:= fixup.o
> > -pci-$(CONFIG_ACPI)		+= acpi.o
> > -pci-y				+= legacy.o irq.o
> > +obj-y				+= fixup.o
> 
> Hi Robert.
> Now I see the full patch I understood your comment.
> I had missed that there was assignments above fixup.o

Yes, it was not the first entry.

-Robert

> 
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> 	Sam
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

