Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbYCSXl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbYCSXl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762095AbYCSWKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:10:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58276 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939837AbYCSWKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:10:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: ACPI regression in 2.6.25-rc6 (function keys stop working)
Date: Wed, 19 Mar 2008 23:10:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Tim Elliott <tle@holymonkey.com>, Guillaume Chazarain <guichaz@gmail.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       lenb@kernel.org
References: <3d8471ca0803171713q31b87939y557f6408543ac881@mail.gmail.com> <1a25886d0803181023o785efa42w523ea48896a0331c@mail.gmail.com> <47E01C86.9080306@suse.de>
In-Reply-To: <47E01C86.9080306@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192310.18692.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 18 of March 2008, Alexey Starikovskiy wrote:
> Tim Elliott wrote:
> > I am seeing the same problem on my Lenovo 3000 v100. The function keys
> > stopped working.
> > 
> > tim@tim-len:~$ cat /proc/interrupts
> >            CPU0       CPU1
> >   0:     164105          0   IO-APIC-edge      timer
> >   1:      12560          0   IO-APIC-edge      i8042
> >   9:          6          0   IO-APIC-fasteoi   acpi
> >  12:     117534          0   IO-APIC-edge      i8042
> >  14:         51          0   IO-APIC-edge      ide0
> >  16:         31          0   IO-APIC-fasteoi   uhci_hcd:usb4,
> > i915@pci:0000:00:02.0
> >  18:     121892          0   IO-APIC-fasteoi   uhci_hcd:usb3, iwl3945
> >  19:      36197          0   IO-APIC-fasteoi   uhci_hcd:usb2, ahci
> >  20:       7931          0   IO-APIC-fasteoi   eth0
> >  22:      11071          0   IO-APIC-fasteoi   sdhc0:slot0, HDA Intel
> >  23:          5          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
> > NMI:          0          0   Non-maskable interrupts
> > LOC:      11296      73879   Local timer interrupts
> > RES:      23199      49164   Rescheduling interrupts
> > CAL:        297      27033   function call interrupts
> > TLB:        838       1286   TLB shootdowns
> > TRM:          0          0   Thermal event interrupts
> > THR:          0          0   Threshold APIC interrupts
> > SPU:          0          0   Spurious interrupts
> > ERR:          0
> > 
> > The problem goes away when reverting 2c81ce4c9c37b910210f2640c28e98a0c398dc26
> > 
> > Reverting the above and applying the patch in comment #38 of bug #9998
> > also works (http://bugzilla.kernel.org/show_bug.cgi?id=9998).
> reverting the above and patch in comment #38 of #9998 are the same thing.
> I am really interested if after revert (or application of #38) you notice a
> difference in interrupt count before and after applying #37 from #9998.

What is the relationship between this problem and bug #10279?

Rafael
