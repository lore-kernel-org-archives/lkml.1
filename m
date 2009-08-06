Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbZHFFF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbZHFFF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZHFFF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:05:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZHFFF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:05:56 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH -next] isdn: fix netjet build errors
Date: Thu, 6 Aug 2009 07:05:32 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.25-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20090805172337.b0688db1.sfr@canb.auug.org.au> <20090805092635.6e6df57e.randy.dunlap@oracle.com> <20090805.120302.204538944.davem@davemloft.net>
In-Reply-To: <20090805.120302.204538944.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908060705.33130.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX18fQ71uhcf2YkRf/4AQ2/V4bTosPM8g19/Xqia
 cRzBp6+RXW281E+W3/o0E2xxnqFECCxWBqBfPmZJ5aMJCNxzUy
 sNPWzjPB6DezqIHPzDkFZkVm3kxUQqk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 5. August 2009 21:03:02 David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Wed, 5 Aug 2009 09:26:35 -0700
>
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > Fix netjet driver link errors when ISDN_I4L is not enabled:
> >
> > drivers/built-in.o: In function `mode_tiger':
> > netjet.c:(.text+0x325dc8): undefined reference to `isdnhdlc_rcv_init'
> > netjet.c:(.text+0x325dd5): undefined reference to `isdnhdlc_out_init'
> > drivers/built-in.o: In function `fill_dma':
> > netjet.c:(.text+0x325fb6): undefined reference to `isdnhdlc_encode'
> > drivers/built-in.o: In function `read_dma':
> > netjet.c:(.text+0x32631a): undefined reference to `isdnhdlc_decode'
> > drivers/built-in.o: In function `nj_irq':
> > netjet.c:(.text+0x326e01): undefined reference to `isdnhdlc_encode'
> >
> > or move isdnhdlc.c to some other sub-dir..
> >
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>
> Thanks Randy.
Thanks too. 
>
> Karsten, let me know if you want me to apply this directly to
> net-next-2.6 or if you want to fix it differently or send it
> with other changes you have pending.
>

My original approach was to change the Makefile to enter this directory
unconditional, but it seems that this part of the patch was lost during 
development.  I will send a new patch after testing with different configs.

Karsten


