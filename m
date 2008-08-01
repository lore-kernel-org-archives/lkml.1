Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYHAM4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYHAM4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYHAM4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:56:25 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:16006
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670AbYHAM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:56:24 -0400
X-Trace: 151696647/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQFAL+kkkjDlSwG/2dsb2JhbACBW4lFpgs
X-IronPort-AV: E=Sophos;i="4.31,293,1215385200"; 
   d="scan'208";a="151696647"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Sysrq+B doesn't work on my box
Date: Fri, 1 Aug 2008 13:56:18 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc1-damocles; KDE/4.1.0; x86_64; ; )
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com> <48921A0C.7020909@goop.org> <c4e36d110808010254i2274516q4cef62460fe8e8@mail.gmail.com>
In-Reply-To: <c4e36d110808010254i2274516q4cef62460fe8e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808011356.19027.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 August 2008 10:54:19 Zdenek Kabelac wrote:
> 2008/7/31 Jeremy Fitzhardinge <jeremy@goop.org>:
> > Zdenek Kabelac wrote:
> >> SysRQ+B  doesn't work with right AltGr on my keyboard - but it does
> >> work with the left Alt which I'm not normally using (It's somewhat
> >> easier to use the right one)
> >> Any idea why AltGR+SysRQ+b does not work on T61 ?
> >
> > You can type them separately: AltGr+SysRq, AltGr+b (holding AltGr across
> > the sequence).
>
> Ok this sequence does work - so one mystery solved :)
>
> now the remaining part is.
>
>
> I'll probably try to bisect  rc.sysinit script to check what is the
> first command
> that breaks the reboot  - but if there is any idea what should I test
> first.?

Are you using modules? Maybe a driver is loaded and this upsets the BIOS 
somehow? If that was the case, the driver wouldn't be loaded in an 
init=/bin/sh situation, as you described before.

-- 
Cheers,
Alistair.
