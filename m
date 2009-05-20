Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbZETJT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbZETJT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZETJTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:19:52 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:57457 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZETJTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:19:51 -0400
From: Karsten Keil <keil@b1-systems.de>
Organization: B1-systems
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 01/19] Add XHFC support for embedded Speech-Design board to hfcmulti
Date: Wed, 20 May 2009 11:19:48 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de> <81986b3e8ddbb4501dce5add2707d5dcec449a23.1242739648.git.kkeil@pingi.linux-pingi.de> <87y6ssnr5v.fsf@basil.nowhere.org>
In-Reply-To: <87y6ssnr5v.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905201119.48782.keil@b1-systems.de>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mittwoch, 20. Mai 2009 09:56:44 Andi Kleen wrote:
> Karsten Keil <keil@b1-systems.de> writes:
> > --- a/drivers/isdn/hardware/mISDN/hfc_multi.h
> > +++ b/drivers/isdn/hardware/mISDN/hfc_multi.h
> > @@ -18,6 +18,46 @@
> >  #define	PCI_ENA_MEMIO	0x02
> >
> >  /*
> > + * Defines for the SDG embedded board using the XHFC-4SU chip
> > + */
> > +#ifdef CONFIG_8xx
>
> This seems like a awfully generic name for a (likely global) CONFIG. Can
> you add a descriptive prefix?
>
> -Andi

This config is not set by mISDN, it is set by somepowerpc  sub arch.

Karsten

