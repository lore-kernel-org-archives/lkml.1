Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbZIGBxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbZIGBxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 21:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbZIGBxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 21:53:34 -0400
Received: from fifo99.com ([67.223.236.141]:52689 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387AbZIGBxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 21:53:33 -0400
Subject: Re: [RFC][PATCH 2/2] disable boot interrupts on Intel X58 and 55x0
From: Daniel Walker <dwalker@fifo99.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Olaf Dabrunz <Olaf.Dabrunz@gmx.net>, Stefan Assmann <sassmann@redhat.com>,
       linux-kernel@vger.kernel.org, jcm@redhat.com, sdietrich@novell.com,
       linux-acpi@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       mingo@elte.hu, ktokunag@redhat.com, tglx@linutronix.de, lenb@kernel.org
In-Reply-To: <20090907013742.GB19670@khazad-dum.debian.net>
References: <20090904165525.26294.31112.sendpatchset@t500>
	 <20090904165545.26294.94612.sendpatchset@t500>
	 <1252084019.22928.39.camel@desktop> <4AA22A6F.30003@redhat.com>
	 <1252162040.6877.7.camel@desktop>
	 <20090905161852.GA19706@santana.dyndns.org>
	 <1252170459.6877.44.camel@desktop>
	 <20090907013742.GB19670@khazad-dum.debian.net>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 18:53:45 -0700
Message-Id: <1252288425.2139.11.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 22:37 -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 05 Sep 2009, Daniel Walker wrote:
> > I'm not sure I see how this makes "adding/deleting/modifying" easier ..
> > We have lots of other situations where lines are broken down less than
> > 80, function arguments, macros, structures all sorts of stuff. 
> > 
> > Taking this block for instance,
> > 
> > DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> >                         PCI_DEVICE_ID_TIGON3_5780,
> >                         quirk_msi_intx_disable_bug);
> > DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> >                         PCI_DEVICE_ID_TIGON3_5780S,
> >                         quirk_msi_intx_disable_bug);
> > DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> >                         PCI_DEVICE_ID_TIGON3_5714,
> >                         quirk_msi_intx_disable_bug);
> > DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> >                         PCI_DEVICE_ID_TIGON3_5714S,
> >                         quirk_msx_intx_disable_bug);
> > DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> >                         PCI_DEVICE_ID_TIGON3_5715,
> >                         quirk_msi_intx_disable_bug);
> > DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
> >                         PCI_DEVICE_ID_TIGON3_5715S,
> >                         quirk_msi_intx_disable_bug);
> 
> You must have an alien brain of some sort if reading that is easier than the
> tabular (single-line) format for you.

My terminal isn't at 130 ..

> Please try finding the one entry in there which is different (I changed one
> of them) with a quick glance.  Chances are you'll just skip over it and
> think all of them do the same thing.

msix , the letters didn't line up, the semicolons don't line up either..
Even with tabs all this information is so similar your bound to overlook
small errors like that. Even if you think all this matter, assume
someone has a term at 80 then every thing is wrapper. That would put you
in the same situation. 

Daniel

Daniel

