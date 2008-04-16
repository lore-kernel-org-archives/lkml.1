Return-Path: <linux-kernel-owner+w=401wt.eu-S1765139AbYDPPDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765139AbYDPPDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYDPPDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:03:23 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54264 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405AbYDPPDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:03:22 -0400
Message-Id: <1208358201.900.1248216803@webmail.messagingengine.com>
X-Sasl-Enc: DU+Aan1MilLClzyu2UsGzRIIPjmSCX1438dxzkq+5vKh 1208358201
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1208191719.12568.1247788911@webmail.messagingengine.com>
   <20080416125724.GC6304@elte.hu>
   <20080416135508.GA16439@mailshack.com>
   <20080416144051.GH24383@elte.hu>
Subject: Re: [PATCH] x86: fix find_next_bit breakage on ppc and powerpc
In-Reply-To: <20080416144051.GH24383@elte.hu>
Date: Wed, 16 Apr 2008 17:03:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Apr 2008 16:40:51 +0200, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
> > Powerpc (and ppc) have their have some code in their bitops.h which 
> > used to be exacly the same as asm-generic/bitops/find.h. Include this 
> > header instead.
> > 
> > This should also fix the compile problems due to the generic 
> > find_next_bit changes. Those were fixed by Thomas Gleixner in 
> > asm-generic/bitops/find.h earlier.
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> thanks, applied. I dropped:
> 
>   Subject: powerpc: fix powerpc build
>   From: Thomas Gleixner <tglx@linutronix.de>
> 
> and i'm keeping:
> 
>   Subject: generic: find_next_bit() fix
>   From: Thomas Gleixner <tglx@linutronix.de>
> 
> should i also drop:
> 
>   Subject: find_first_bit() ppc fix
>   From: Thomas Gleixner <tglx@linutronix.de>
> 
> ?

Yes, that problem should be fixed by my patch.

Thanks,
    Alexander

> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Does exactly what it says on the tin

