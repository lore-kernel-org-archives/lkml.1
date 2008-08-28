Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYH1Pkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYH1Pkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbYH1PkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:40:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:40588 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbYH1PkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:40:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,286,1217833200"; 
   d="scan'208";a="374427004"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "i2c@lm-sensors.org" <i2c@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Thu, 28 Aug 2008 08:40:16 -0700
Subject: RE: [PATCH 2.6.27-rc4] irq: irq and pci_ids patch for Intel Ibex
   Peak DeviceIDs
Thread-Topic: [PATCH 2.6.27-rc4] irq: irq and pci_ids patch for Intel Ibex
   Peak DeviceIDs
Thread-Index: AckJIw8eN9D18w60QUuv9HfKPw3eDAAAB/kg
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF177A1752@orsmsx501.amr.corp.intel.com>
References: <200808271658.26313.seth.heasley@intel.com>
	<20080828094935.0f50af24@hyperion.delvare>
	<200808280712.47908.jbarnes@virtuousgeek.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF177A16F0@orsmsx501.amr.corp.intel.com>
 <20080828173035.73069de6@hyperion.delvare>
In-Reply-To: <20080828173035.73069de6@hyperion.delvare>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Thu, 28 Aug 2008 08:18:19 -0700, Heasley, Seth wrote:
>> >On Thursday, August 28, 2008 12:49 am Jean Delvare wrote:
>> >> Hi Seth,
>> >>
>> >> On Wed, 27 Aug 2008 16:58:26 -0700, Seth Heasley wrote:
>> >> > This patch updates the Intel Ibex Peak (PCH) LPC and SMBus
>Controller
>> >> > DeviceIDs.
>> >> >
>> >> > Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>> >> >
>> >> > --- linux-2.6/include/linux/pci_ids.h.orig  2008-08-27
>> >11:54:07.000000000
>> >> > -0700 +++ linux-2.6/include/linux/pci_ids.h 2008-08-27
>> >12:01:53.000000000
>> >> > -0700 @@ -2428,9 +2428,39 @@
>> >> >  #define PCI_DEVICE_ID_INTEL_ICH10_3        0x3a1a
>> >> >  #define PCI_DEVICE_ID_INTEL_ICH10_4        0x3a30
>> >> >  #define PCI_DEVICE_ID_INTEL_ICH10_5        0x3a60
>> >> > -#define PCI_DEVICE_ID_INTEL_PCH_0  0x3b10
>> >> > -#define PCI_DEVICE_ID_INTEL_PCH_1  0x3b11
>> >> > -#define PCI_DEVICE_ID_INTEL_PCH_2  0x3b30
>> >> > +#define PCI_DEVICE_ID_INTEL_PCH_0  0x3b00
>> >> > +#define PCI_DEVICE_ID_INTEL_PCH_1  0x3b01
>> >> > +#define PCI_DEVICE_ID_INTEL_PCH_2  0x3b02
>> >>
>> >> Changing device ID definitions that way is really bad practice. It
>> >> needs to be synchronized between all involved subsystems.
>> >>
>> >> > --- linux-2.6/arch/x86/pci/irq.c.orig       2008-08-27
>> >11:53:13.000000000 -0700
>> >> > +++ linux-2.6/arch/x86/pci/irq.c    2008-08-27 12:07:21.000000000 -
>0700
>> >> > @@ -592,6 +592,36 @@
>> >> >     case PCI_DEVICE_ID_INTEL_ICH10_3:
>> >> >     case PCI_DEVICE_ID_INTEL_PCH_0:
>> >> >     case PCI_DEVICE_ID_INTEL_PCH_1:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_2:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_3:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_4:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_5:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_6:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_7:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_8:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_9:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_10:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_11:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_12:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_13:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_14:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_15:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_16:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_17:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_18:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_19:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_20:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_21:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_22:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_23:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_24:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_25:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_26:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_27:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_28:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_29:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_30:
>> >> > +   case PCI_DEVICE_ID_INTEL_PCH_31:
>> >>
>> >> I am no PCI IRQ routing expert, but I have to admit that I a bit
>> >> skeptical that all the PCH functions are IRQ routers. You're adding as
>> >> many entries here for the PCH than there have been for all Intel chips
>> >> in the past 10 years or so...
>> >>
>> >> >             r->name = "PIIX/ICH";
>> >> >             r->get = pirq_piix_get;
>> >> >             r->set = pirq_piix_set;
>> >
>> >Yeah, this has me confused now too.  I remember specifically asking if
>the
>> >other PCHs needed to be added to this list when the last patch was
>applied..
>> >What happened?  Can you give us some more background here, Seth?  The
>> >changelog should definitely include an explanation of why the IDs need
>to
>> >be
>> >changed (i.e. why the old commit was wrong).
>> >
>> >Thanks,
>> >--
>> >Jesse Barnes, Intel Open Source Technology Center
>>
>> I'm not sure what's "messy," given that I changed what was required
>> to be changed, then added the new IDs.  These IDs are as follows:
>>
>> LPC Controller: 3b00-3b1f (final ID set in Firmware, but 32
>possibilities)
>> SMBus: 3b30
>>
>> In terms of the irq stuff, I'm adding only the LPC Controller IDs
>> there.  There are just a lot of them.  Normally we have a handful of
>> IDs, but in this case the list is longer.
>
>So basically, you (Intel) have no clue what IDs will be used, and
>instead of waiting until you have the information, you prefer to add a
>bunch of device IDs to the Linux kernel, most of which will never
>exist? This is making the kernel code bigger and slower. Not by much,
>but still... That's bad engineering, really. Especially if you don't
>clean up afterwards, as happens to be the case for the ICH10. I
>compared the ICH10 datasheet with the IDs we have in the kernel and
>only 3 of the 6 defined device IDs are actually used by existing ICH10
>chips.

I can't speak to the engineering, although I agree that blocking out 32 IDs is strange.  I don't believe it's a matter of not knowing what will be used but rather that the firmware has the flexibility to change the ID in that range.

On the ICH10 side, we don't have a datasheet released yet for one of the skus of the product (the other sku has not launched).  The other three IDs are from that sku.  No cleanup will be needed.

>
>> I suppose what "messy" means is, I should have kept the existing
>> defines and only added the new?  I can resubmit if that's the way
>> it should be done.
>
>That's one part of the messiness, yes. Which underlines how bad the
>symbol naming scheme is to start with.
>

I have no history here, but I'm inclined to agree it's a strange naming scheme.

-Seth
