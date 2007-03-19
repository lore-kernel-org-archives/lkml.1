Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbXCSDR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbXCSDR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 23:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933788AbXCSDR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 23:17:27 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:52759 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780AbXCSDRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 23:17:25 -0400
From: eiichiro.oiwa.nm@hitachi.com
Message-Type: Multiple Part
MIME-Version: 1.0
Message-ID: <XNM1$9$0$4$$3$3$7$A$9002870U45fdffb3@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
To: "Jesse Barnes" <jesse.barnes@intel.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, <akpm@osdl.org>,
       <tony.luck@intel.com>, <greg@kroah.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <linux-ia64@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Date: Mon, 19 Mar 2007 12:12:55 +0900
References: <XNM1$9$0$4$$3$3$7$A$9002686U451b55cd@hitachi.com> 
    <200609280936.02098.jesse.barnes@intel.com> 
    <200703161120.46123.bjorn.helgaas@hp.com> 
    <200703161142.39854.jesse.barnes@intel.com>
Importance: normal
Subject: Re: [PATCH 2.6.18] PCI: Turn pci_fixup_video into generic for
    embedded VGA
X400-Content-Identifier: X45FDFFB300000M
X400-MTS-Identifier: [/C=JP/ADMD=HITNET/PRMD=HITACHI/;gmml160703191212518I8]
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On Friday, March 16, 2007 10:20 am Bjorn Helgaas wrote:
>> Are there really ia64 machines where we need to use the option ROM
>> copy at 0xC0000?  If so, is this documented somewhere?  I couldn't
>> find any mention in DIG64, EFI, or internal HP architecture specs.
>>
>> If we do need to use it, ia64 has a bit of a problem because on some
>> boxes, the 0xC0000 memory supports only cacheable access, the VGA
>> frame buffer at 0xA0000 supports only uncacheable access, and the
>> usual ia64 ioremap mapping is a 16MB page that covers both.
>
>Apparently Eichiro's machine needs it, and of course there are i386 and 
>x86_64 machines that need it to, so it makes sense that it be generic.
>
>Jesse
>

Yes, our machine need it.

>> Are there really ia64 machines where we need to use the option ROM
>> copy at 0xC0000?  If so, is this documented somewhere?  I couldn't
>> find any mention in DIG64, EFI, or internal HP architecture specs.

"System Abstraction Layer Specification" describes it in section 2.6.

Eiichiro

