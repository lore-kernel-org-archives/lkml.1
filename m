Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbYHAV0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbYHAV0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762630AbYHAVR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:17:59 -0400
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:46766
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762626AbYHAVR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:17:58 -0400
X-Trace: 64428217/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQFAO8Zk0jDlSwG/2dsb2JhbACBW4lEpRs
X-IronPort-AV: E=Sophos;i="4.31,295,1215385200"; 
   d="scan'208";a="64428217"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Sysrq+B doesn't work on my box
Date: Fri, 1 Aug 2008 22:17:53 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc1-damocles; KDE/4.1.0; x86_64; ; )
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com> <c4e36d110808010622w74d61378ud9624a6ea38357a4@mail.gmail.com> <c4e36d110808011325q612d57dcnfe99e6ef42b1c4ae@mail.gmail.com>
In-Reply-To: <c4e36d110808011325q612d57dcnfe99e6ef42b1c4ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808012217.53449.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2008/8/1 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> > 2008/8/1 Alistair John Strachan <alistair@devzero.co.uk>:
> >> On Friday 01 August 2008 10:54:19 Zdenek Kabelac wrote:
> >>> 2008/7/31 Jeremy Fitzhardinge <jeremy@goop.org>:
> >>> > Zdenek Kabelac wrote:
> >>>
> >>> I'll probably try to bisect  rc.sysinit script to check what is the
> >>> first command
> >>> that breaks the reboot  - but if there is any idea what should I test
> >>> first.?
> >>
> >> Are you using modules? Maybe a driver is loaded and this upsets the BIOS
> >> somehow? If that was the case, the driver wouldn't be loaded in an
> >> init=/bin/sh situation, as you described before.
> >
> > Yes - except as I've checked the exactly same modularized kernel
> > running Debian on the same box
> > has no boot problem.
>
> Ok - idea with checking loaded modules was actually the right way to a
> very quick discovery that KVM loaded in my Fedora are the source of
> troubles - without them the second mystery is also a history :)
>
> So - is it normal, that loaded KVM modules eliminate emergency reboot
> (bug or feature)?

Obviously not :-) Added Avi to CC.

Avi, Zdenek is having a problem on his T61 where the Alt-SysRq-B emergency 
reboot mechanism stops working after he loads the KVM module. Any ideas?

-- 
Cheers,
Alistair.
