Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbYH1ONG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbYH1ONG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYH1OM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:12:56 -0400
Received: from outbound-mail-17.bluehost.com ([69.89.20.232]:35357 "HELO
	outbound-mail-17.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752636AbYH1OMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:12:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=jX0zZve6v3xeuzgquelnhdWdO53vhi/fg6zh4Eywk4ytSdBOYS9mP6AC1mYCtirC4lxCkSc4LiaHgbJTjkYhk0BS2eHtCI9GQp5UfgE2Ffd+k6zJK6FKcv330sz8XNig;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 2.6.27-rc4] irq: irq and pci_ids patch for Intel Ibex  Peak DeviceIDs
Date: Thu, 28 Aug 2008 07:12:47 -0700
User-Agent: KMail/1.9.9
Cc: Seth Heasley <seth.heasley@intel.com>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <200808271658.26313.seth.heasley@intel.com> <20080828094935.0f50af24@hyperion.delvare>
In-Reply-To: <20080828094935.0f50af24@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808280712.47908.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 28, 2008 12:49 am Jean Delvare wrote:
> Hi Seth,
>
> On Wed, 27 Aug 2008 16:58:26 -0700, Seth Heasley wrote:
> > This patch updates the Intel Ibex Peak (PCH) LPC and SMBus Controller
> > DeviceIDs.
> >
> > Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> >
> > --- linux-2.6/include/linux/pci_ids.h.orig	2008-08-27 11:54:07.000000000
> > -0700 +++ linux-2.6/include/linux/pci_ids.h	2008-08-27 12:01:53.000000000
> > -0700 @@ -2428,9 +2428,39 @@
> >  #define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
> >  #define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
> >  #define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
> > -#define PCI_DEVICE_ID_INTEL_PCH_0	0x3b10
> > -#define PCI_DEVICE_ID_INTEL_PCH_1	0x3b11
> > -#define PCI_DEVICE_ID_INTEL_PCH_2	0x3b30
> > +#define PCI_DEVICE_ID_INTEL_PCH_0	0x3b00
> > +#define PCI_DEVICE_ID_INTEL_PCH_1	0x3b01
> > +#define PCI_DEVICE_ID_INTEL_PCH_2	0x3b02
>
> Changing device ID definitions that way is really bad practice. It
> needs to be synchronized between all involved subsystems.
>
> > --- linux-2.6/arch/x86/pci/irq.c.orig	2008-08-27 11:53:13.000000000 -0700
> > +++ linux-2.6/arch/x86/pci/irq.c	2008-08-27 12:07:21.000000000 -0700
> > @@ -592,6 +592,36 @@
> >  	case PCI_DEVICE_ID_INTEL_ICH10_3:
> >  	case PCI_DEVICE_ID_INTEL_PCH_0:
> >  	case PCI_DEVICE_ID_INTEL_PCH_1:
> > +	case PCI_DEVICE_ID_INTEL_PCH_2:
> > +	case PCI_DEVICE_ID_INTEL_PCH_3:
> > +	case PCI_DEVICE_ID_INTEL_PCH_4:
> > +	case PCI_DEVICE_ID_INTEL_PCH_5:
> > +	case PCI_DEVICE_ID_INTEL_PCH_6:
> > +	case PCI_DEVICE_ID_INTEL_PCH_7:
> > +	case PCI_DEVICE_ID_INTEL_PCH_8:
> > +	case PCI_DEVICE_ID_INTEL_PCH_9:
> > +	case PCI_DEVICE_ID_INTEL_PCH_10:
> > +	case PCI_DEVICE_ID_INTEL_PCH_11:
> > +	case PCI_DEVICE_ID_INTEL_PCH_12:
> > +	case PCI_DEVICE_ID_INTEL_PCH_13:
> > +	case PCI_DEVICE_ID_INTEL_PCH_14:
> > +	case PCI_DEVICE_ID_INTEL_PCH_15:
> > +	case PCI_DEVICE_ID_INTEL_PCH_16:
> > +	case PCI_DEVICE_ID_INTEL_PCH_17:
> > +	case PCI_DEVICE_ID_INTEL_PCH_18:
> > +	case PCI_DEVICE_ID_INTEL_PCH_19:
> > +	case PCI_DEVICE_ID_INTEL_PCH_20:
> > +	case PCI_DEVICE_ID_INTEL_PCH_21:
> > +	case PCI_DEVICE_ID_INTEL_PCH_22:
> > +	case PCI_DEVICE_ID_INTEL_PCH_23:
> > +	case PCI_DEVICE_ID_INTEL_PCH_24:
> > +	case PCI_DEVICE_ID_INTEL_PCH_25:
> > +	case PCI_DEVICE_ID_INTEL_PCH_26:
> > +	case PCI_DEVICE_ID_INTEL_PCH_27:
> > +	case PCI_DEVICE_ID_INTEL_PCH_28:
> > +	case PCI_DEVICE_ID_INTEL_PCH_29:
> > +	case PCI_DEVICE_ID_INTEL_PCH_30:
> > +	case PCI_DEVICE_ID_INTEL_PCH_31:
>
> I am no PCI IRQ routing expert, but I have to admit that I a bit
> skeptical that all the PCH functions are IRQ routers. You're adding as
> many entries here for the PCH than there have been for all Intel chips
> in the past 10 years or so...
>
> >  		r->name = "PIIX/ICH";
> >  		r->get = pirq_piix_get;
> >  		r->set = pirq_piix_set;

Yeah, this has me confused now too.  I remember specifically asking if the 
other PCHs needed to be added to this list when the last patch was applied.  
What happened?  Can you give us some more background here, Seth?  The 
changelog should definitely include an explanation of why the IDs need to be 
changed (i.e. why the old commit was wrong).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
