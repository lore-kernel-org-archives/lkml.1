Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbZETMS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbZETMS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbZETMSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:18:20 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:54581 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283AbZETMST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:18:19 -0400
From: Karsten Keil <keil@b1-systems.de>
Organization: B1-systems
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 01/19] Add XHFC support for embedded Speech-Design board to hfcmulti
Date: Wed, 20 May 2009 14:18:14 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de,
       Andreas Eversberg <andreas@eversberg.eu>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de> <200905201119.48782.keil@b1-systems.de> <20090520113813.GE8684@one.firstfloor.org>
In-Reply-To: <20090520113813.GE8684@one.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905201418.15232.keil@b1-systems.de>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 20. Mai 2009 13:38:13 Andi Kleen wrote:
> Hi Karsten,
>
> > This config is not set by mISDN, it is set by somepowerpc  sub arch.
>
> That still seems like a rather quirky way to do this then, making
> drivers dependent on specific architectures. This kind
> of thing lead to ifdef jungles in the past, hopefully not done
> again in new drivers.

Andy,  thanks for you comments.

Yes I did not like this part as well and this was the reason why I did not 
include this patch in my previous update in January. I only fixed some 
codestyle issues now.

Let discuss this with the author (CC'ed now).

>
> Standard ways to handle this:
> - If the driver needs something special only this architecture can
> provide make the architecture set a special HAS... config option.
> - Provide a special asm include file that is stubbed out
> by other architectures.
> - Put the arch specific code in another file and make that dependent on the
> HAS_...  symbol in the Makefile.

Do you have a pointer to a good example here ?

It seems that this architecture (used by an existing embedded board) have
very specific IO method to this hardware so this should go into a separate 
file.

Karsten

