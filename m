Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZIGBhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZIGBhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 21:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbZIGBhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 21:37:45 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36137 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758395AbZIGBho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 21:37:44 -0400
X-Sasl-enc: JPmMPO95XeAPfmEhxfsPmWoepPmI1jlsjcSZOBI/OYcf 1252287466
Date: Sun, 6 Sep 2009 22:37:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Olaf Dabrunz <Olaf.Dabrunz@gmx.net>, Stefan Assmann <sassmann@redhat.com>,
       linux-kernel@vger.kernel.org, jcm@redhat.com, sdietrich@novell.com,
       linux-acpi@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       mingo@elte.hu, ktokunag@redhat.com, tglx@linutronix.de, lenb@kernel.org
Subject: Re: [RFC][PATCH 2/2] disable boot interrupts on Intel X58 and 55x0
Message-ID: <20090907013742.GB19670@khazad-dum.debian.net>
References: <20090904165525.26294.31112.sendpatchset@t500>
 <20090904165545.26294.94612.sendpatchset@t500>
 <1252084019.22928.39.camel@desktop>
 <4AA22A6F.30003@redhat.com>
 <1252162040.6877.7.camel@desktop>
 <20090905161852.GA19706@santana.dyndns.org>
 <1252170459.6877.44.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252170459.6877.44.camel@desktop>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Sep 2009, Daniel Walker wrote:
> I'm not sure I see how this makes "adding/deleting/modifying" easier ..
> We have lots of other situations where lines are broken down less than
> 80, function arguments, macros, structures all sorts of stuff. 
> 
> Taking this block for instance,
> 
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>                         PCI_DEVICE_ID_TIGON3_5780,
>                         quirk_msi_intx_disable_bug);
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>                         PCI_DEVICE_ID_TIGON3_5780S,
>                         quirk_msi_intx_disable_bug);
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>                         PCI_DEVICE_ID_TIGON3_5714,
>                         quirk_msi_intx_disable_bug);
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>                         PCI_DEVICE_ID_TIGON3_5714S,
>                         quirk_msix_intx_disable_bug);
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>                         PCI_DEVICE_ID_TIGON3_5715,
>                         quirk_msi_intx_disable_bug);
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>                         PCI_DEVICE_ID_TIGON3_5715S,
>                         quirk_msi_intx_disable_bug);

You must have an alien brain of some sort if reading that is easier than the
tabular (single-line) format for you.

Please try finding the one entry in there which is different (I changed one
of them) with a quick glance.  Chances are you'll just skip over it and
think all of them do the same thing.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
